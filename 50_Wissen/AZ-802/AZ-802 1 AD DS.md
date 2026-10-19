---
typ: wissen
thema: AZ-802
tags: [az-802, ad-ds, windows-server, exam]
aliases: [AZ-802 Bereich 1, AZ-802 AD DS]
gewicht: "20–25 %"
erstellt: 2026-10-19
status: lernen
---
# AZ-802 Bereich 1 – AD DS bereitstellen und verwalten (20–25 %)

Kapitel: [[AZ-802 Übersicht]] · Weiter: [[AZ-802 2 Hybride Verwaltung]]
Vorwissen: [[AD DS Überblick]] · [[AD-Gruppen und AGDLP]] · [[Vertrauensstellungen]] · [[Gruppenrichtlinien]] · [[PowerShell AD und GPO]]

## Prüfungsziele (Checkliste)
- [ ] Domänencontroller lokal bereitstellen und verwalten → [[AD DS Überblick]]
- [ ] Domänencontroller **in Azure** bereitstellen → Abschnitt 1
- [ ] [[RODC]] bereitstellen, Kontosicherheit auf dem RODC verwalten → Abschnitt 2
- [ ] [[FSMO]]-Rollen verwalten und Fehler beheben → Abschnitt 3
- [ ] Domänen- und Gesamtstruktur-Vertrauensstellungen → [[Vertrauensstellungen]]
- [ ] [[AD-Standort|AD-Standorte]] und Replikation → Abschnitt 4
- [ ] Benutzer und Gruppen (auch über Domänen/Forests) → [[AD-Gruppen und AGDLP]]
- [ ] Dienstkonten auswählen und verwalten → Abschnitt 5
- [ ] Gruppenrichtlinien und Einstellungen (Preferences) → [[Gruppenrichtlinien]]

## 1. Domänencontroller in Azure
| Regel | Warum |
|---|---|
| Private IP **statisch in der Azure-NIC** festlegen – im Gast DHCP lassen | Azure verwaltet die Adresse; statische IP im Gast kann die VM unerreichbar machen |
| VNet-DNS-Server = IP der DCs (nicht Azure-DNS) | Clients müssen die Domäne finden |
| NTDS-Datenbank, Logs und SYSVOL auf **Datendatenträger** mit Hostcache **Keine** | Schreibcache gefährdet die AD-Datenbank |
| Eigenen [[AD-Standort]] + Subnetz für das Azure-VNet | Clients nutzen den nahen DC, Replikation planbar |
| 2 DCs in [[Verfügbarkeitszone\|Verfügbarkeitszonen]] oder einer [[Verfügbarkeitsgruppe]] | Ausfallsicherheit |
| Verbindung per VPN-Gateway/ExpressRoute | Replikation mit lokalen DCs |
| Keine Wiederherstellung per Disk-Snapshot ohne Hyper-V/Azure-Unterstützung der [[VM-GenerationID]] | Gefahr [[USN-Rollback]] |

## 2. RODC (schreibgeschützter DC)
- Für Außenstellen ohne sichere Serverräume. Hat **keine** beschreibbare Datenbank, speichert standardmäßig **keine Kennwörter**.
- **Kennwortreplikationsrichtlinie (PRP):** Gruppe *Zulässige RODC-Kennwortreplikationsgruppe* (Allowed) und *Abgelehnte …* (Denied, enthält Admins – Verweigern gewinnt).
- **Administratorrollentrennung:** lokaler Admin am RODC ohne Domänen-Admin-Rechte.
- **Gestaffelte Bereitstellung:** Konto vorab anlegen, Server tritt später bei.
- Bei Diebstahl: RODC-Konto löschen → Kennwörter der zwischengespeicherten Konten zurücksetzen lassen.

```powershell
# Maschine: EXA-DC01 – RODC-Konto vorab anlegen (gestaffelt)
Add-ADDSReadOnlyDomainControllerAccount -DomainControllerAccountName EXA-RODC01 `
  -DomainName example.com -SiteName Aussenstelle -DelegatedAdministratorAccountName 'EXAMPLE\rodc-admin'
# PRP: Benutzergruppe darf Kennwort zwischenspeichern
Add-ADDomainControllerPasswordReplicationPolicy -Identity EXA-RODC01 -AllowedList 'GG_Aussenstelle'
Get-ADDomainControllerPasswordReplicationPolicyUsage -Identity EXA-RODC01 -RevealedAccounts
# Maschine: EXA-RODC01 – zum RODC heraufstufen
Install-ADDSDomainController -DomainName example.com -ReadOnlyReplica -SiteName Aussenstelle -InstallDns -Credential (Get-Credential)
```

## 3. FSMO-Rollen
| Rolle | Ebene | Aufgabe | Ausfall merkt man … |
|---|---|---|---|
| Schemamaster | Gesamtstruktur | Schemaänderungen | erst bei Schema-Erweiterung |
| Domänennamenmaster | Gesamtstruktur | Domänen hinzufügen/entfernen | selten |
| RID-Master | Domäne | RID-Pools für neue Objekte | wenn Pools leer → keine neuen Konten |
| PDC-Emulator | Domäne | Zeitquelle, Kennwortänderungen, Kontosperre, GPO-Bearbeitung | **sofort** (Zeit, Anmeldungen) |
| Infrastrukturmaster | Domäne | Verweise auf Objekte anderer Domänen | bei Multi-Domain |

- **Übertragen** (alter Inhaber online) vs. **Übernehmen/seize** (alter Inhaber dauerhaft weg – darf **nie** wieder ans Netz).
```powershell
# Maschine: EXA-DC01
netdom query fsmo
Get-ADDomain | Select-Object PDCEmulator, RIDMaster, InfrastructureMaster
Get-ADForest | Select-Object SchemaMaster, DomainNamingMaster
# übertragen auf EXA-DC02
Move-ADDirectoryServerOperationMasterRole -Identity EXA-DC02 -OperationMasterRole PDCEmulator, RIDMaster
# übernehmen (Notfall)
Move-ADDirectoryServerOperationMasterRole -Identity EXA-DC02 -OperationMasterRole SchemaMaster -Force
```

## 4. Standorte und Replikation
- **Standort** = gut verbundene IP-Subnetze. Steuert DC-Suche der Clients und Replikation.
- **Standortverknüpfung:** Kosten (Standard 100) und Intervall (Standard **180 Min.**, min. 15).
- Innerhalb eines Standorts: Änderungsbenachrichtigung nach ~15 s. Zwischen Standorten: nach Zeitplan, komprimiert, über **Brückenkopfserver**.
- **KCC** baut die Topologie automatisch; **ISTG** für standortübergreifende Verbindungen.
```powershell
# Maschine: EXA-DC01
New-ADReplicationSite -Name Azure-GWC
New-ADReplicationSubnet -Name 10.10.0.0/16 -Site Azure-GWC
New-ADReplicationSiteLink -Name 'HQ-Azure' -SitesIncluded Default-First-Site-Name, Azure-GWC -Cost 100 -ReplicationFrequencyInMinutes 15
repadmin /replsummary
repadmin /syncall /AdeP
```

## 5. Dienstkonten
| Typ | Für | Kennwort | Seit |
|---|---|---|---|
| Normales Benutzerkonto | – | manuell, läuft ab | – (vermeiden) |
| sMSA (eigenständiges MSA) | **einen** Server | automatisch | 2008 R2 |
| [[gMSA]] (gruppenverwaltetes MSA) | **mehrere** Server (Farm, Cluster, Tasks) | automatisch, KDS-Stammschlüssel nötig | 2012 |
| dMSA (delegiertes MSA) | Ablösung alter Dienstkonten | automatisch, an Gerät gebunden | **2025** |
| Virtuelles Konto (`NT SERVICE\Dienst`) | lokaler Dienst | automatisch | 2008 R2 |

```powershell
# Maschine: EXA-DC01 – einmal pro Gesamtstruktur (Lab: sofort gültig)
Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10))
New-ADServiceAccount -Name gmsa-web -DNSHostName gmsa-web.example.com `
  -PrincipalsAllowedToRetrieveManagedPassword 'GG_Webserver'
# Maschine: EXA-WEB01 (Mitglied von GG_Webserver, ggf. Neustart)
Install-ADServiceAccount gmsa-web
Test-ADServiceAccount gmsa-web      # True
```

## 6. Gruppenrichtlinien – prüfungsrelevante Details
- Verarbeitung **LSDOU**: Lokal → Standort → Domäne → OU; „Erzwungen“ schlägt „Vererbung deaktivieren“.
- Filter: Sicherheitsfilter, WMI-Filter, bei Einstellungen (Preferences) **Zielgruppenadressierung auf Elementebene**.
- Loopback (Ersetzen/Zusammenführen) für Terminalserver.
- Zentraler Speicher für ADMX: `\\example.com\SYSVOL\example.com\Policies\PolicyDefinitions`.
- Diagnose: `gpresult /h bericht.html`, `Get-GPResultantSetOfPolicy`, `gpupdate /force`.

## Fallen
- Seized FSMO-Inhaber nie wieder online bringen.
- RODC kann keine Schreibvorgänge annehmen – Anwendungen, die schreiben, brauchen einen beschreibbaren DC.
- gMSA: Server muss in der berechtigten Gruppe sein **und** das Kerberos-Ticket neu holen (Neustart oder `klist purge -li 0x3e7`).
- Standorte ohne Subnetz-Zuordnung → Clients authentifizieren sich irgendwo.

## Glossar
[[RODC]] · [[FSMO]] · [[AD-Standort]] · [[gMSA]] · [[DFSR]] · [[GPO]] · [[Kerberos]] · [[VM-GenerationID]] · [[USN-Rollback]]
