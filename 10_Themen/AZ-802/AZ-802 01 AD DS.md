---
aliases: [AD DS AZ-802]
tags: [az-802, az-802/ad-ds, thema]
bereich: 01
gewicht: 20–25 %
status: offen
---
# 01 AD DS bereitstellen und verwalten (20–25 %)
↑ [[AZ-802 MOC]] · Lab: [[AZ-802 Lab 01 AD DS - Aufgaben]]

## Prüfungsziele
- [ ] DCs lokal + in Azure bereitstellen
- [ ] RODC bereitstellen, Kontosicherheit (PRP) verwalten
- [ ] FSMO-Rollen verwalten / Fehler beheben (Transfer, Seize)
- [ ] Domänen- und Forest-Trusts
- [ ] Standorte, Subnetze, Standortverknüpfungen
- [ ] Replikation konfigurieren/verwalten
- [ ] Benutzer/Gruppen (auch Multi-Domäne/Forest)
- [ ] Dienstkonten wählen/verwalten (sMSA, gMSA, dMSA)
- [ ] GPO implementieren + Einstellungen (Preferences)

## Kernwissen

### DC-Bereitstellung
| Weg | Werkzeug | Merkpunkt |
|---|---|---|
| Neuer Forest | `Install-ADDSForest` | erster DC = alle FSMO + GC |
| Zusätzlicher DC | `Install-ADDSDomainController` | DNS + GC empfohlen |
| IFM (Install from Media) | `ntdsutil "ac i ntds" ifm` | spart Replikation über WAN |
| DC in Azure | Azure-VM, **statische private IP**, NTDS/SYSVOL auf **Datendisk mit Host-Cache = None** | nie aus Image klonen ohne Sysprep-Regeln |

### RODC
- Keine Schreibrechte, unidirektionale Replikation, für Außenstellen mit geringer physischer Sicherheit.
- **PRP** (Password Replication Policy): Gruppen *Allowed RODC Password Replication Group* / *Denied …*
- Admin-Rollentrennung: lokaler Admin am RODC ohne Domain-Admin (`dsmgmt`).
- Voraussetzung: Writable DC mit Server 2008+ erreichbar.

### FSMO
| Rolle | Ebene | Ausfall merkt man an |
|---|---|---|
| Schema Master | Forest | Schemaerweiterung schlägt fehl |
| Domain Naming Master | Forest | Domäne hinzufügen/entfernen unmöglich |
| RID Master | Domäne | keine neuen Objekte, wenn RID-Pool leer |
| PDC Emulator | Domäne | Zeit, Kennwortänderungen, Sperren, GPO-Bearbeitung |
| Infrastructure Master | Domäne | Cross-Domain-Referenzen veralten |
- Transfer: `Move-ADDirectoryServerOperationMasterRole`; **Seize** = gleicher Befehl + `-Force` (alter DC darf nie zurückkommen).
- Zeitquelle: PDC des Forest-Root → externe NTP-Quelle.

### Trusts
| Typ | Transitiv | Richtung | Einsatz |
|---|---|---|---|
| Parent-Child / Tree-Root | ja | 2-weg | automatisch |
| Forest | ja (zw. 2 Forests) | 1/2-weg | contoso ↔ example |
| External | nein | 1/2-weg | einzelne Domäne, NT4-Stil |
| Shortcut | ja | 1/2-weg | Auth-Weg verkürzen |
| Realm | optional | 1/2-weg | Kerberos (Linux/MIT) |
- **Richtung**: vertrauende Domäne → vertraute Domäne. Zugriff fließt **entgegen** der Vertrauensrichtung.
- **Selektive Authentifizierung**: Recht *Allowed to authenticate* am Computerobjekt nötig.
- **SID-Filterung**: standardmäßig bei External/Forest an.
- Voraussetzung Forest-Trust: DNS-Auflösung beider Seiten (bedingte Weiterleitung), Forest-Funktionsebene ≥ 2003.

### Standorte & Replikation
- Standort = IP-Subnetze mit guter Anbindung. Standortverknüpfung: **Kosten**, **Intervall** (min. 15 Min), Zeitplan.
- KCC baut Topologie automatisch; **ISTG** pro Standort für standortübergreifende Verbindungen.
- Bridgehead-Server: bevorzugt manuell festlegen nur wenn nötig.
- Intra-Site: Änderungsbenachrichtigung (~15 s). Inter-Site: Zeitplan, komprimiert.
- SYSVOL-Replikation: **DFSR** (FRS veraltet).

### Sicherheitsprinzipale
| Gruppenbereich | Mitglieder aus | Rechte in |
|---|---|---|
| Domain Local | beliebige Domäne/Forest | eigener Domäne |
| Global | eigener Domäne | jedem vertrauenden Bereich |
| Universal | ganzem Forest | ganzem Forest (im GC gespeichert) |
- Strategie **AGDLP**: Account → Global → Domain Local → Permission (Multi-Domäne: AGUDLP).
- Foreign Security Principals: Container *ForeignSecurityPrincipals* bei Trusts.

### Dienstkonten
| Typ | Kennwort | Mehrere Server | Hinweis |
|---|---|---|---|
| Normales Benutzerkonto | manuell | ja | Risiko, vermeiden |
| sMSA | automatisch | nein | 1 Server |
| gMSA | automatisch (KDS) | ja | `Add-KdsRootKey` zuerst |
| dMSA (Server 2025) | automatisch | – | Migration von Legacy-Dienstkonten |
| Virtuelles Konto | automatisch | lokal | `NT SERVICE\<Dienst>` |

### GPO
- Verarbeitung **LSDOU**: Lokal → Standort → Domäne → OU (spätere gewinnt).
- **Enforced** schlägt *Block Inheritance*. Sicherheitsfilter, WMI-Filter, Loopback (Merge/Replace).
- Preferences (GPP): nicht erzwungen, Item-Level Targeting, z. B. Laufwerke, Drucker, Registry.
- Central Store: `\\example.com\SYSVOL\example.com\Policies\PolicyDefinitions`.
- Diagnose: `gpresult /h`, `Get-GPResultantSetOfPolicy`, `gpupdate /force`.

## Prüfungsfallen
- RODC speichert standardmäßig **keine** Kennwörter.
- Seize nur, wenn Original-DC endgültig weg.
- Trust-Richtung vs. Zugriffsrichtung verwechseln.
- Universal-Gruppenänderungen erzeugen GC-Replikation.
- DC-Datendisk in Azure: Cache **None** (Write-Cache gefährdet NTDS).

## Leitfragen (zuerst selbst beantworten)
1. Warum braucht eine Außenstelle mit RODC trotzdem WAN zum Writable DC für die Erstanmeldung?
2. EXAMPLE-Benutzer sollen auf Freigabe bei CON-DC: Welche Seite vertraut wem?
3. Welcher FSMO-Ausfall fällt am schnellsten auf und warum?
4. Wann gMSA statt sMSA?

## Glossar
[[FSMO]] · [[RODC]] · [[Vertrauensstellung]] · [[gMSA]] · [[KCC]] · [[GPO]] · [[AGDLP]]
