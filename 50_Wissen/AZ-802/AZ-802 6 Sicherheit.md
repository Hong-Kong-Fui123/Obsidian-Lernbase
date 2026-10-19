---
typ: wissen
thema: AZ-802
tags: [az-802, sicherheit, haertung, ad-ds, exam]
aliases: [AZ-802 Bereich 6, AZ-802 Sicherheit, Windows Server härten]
gewicht: "10–15 %"
erstellt: 2026-10-19
status: lernen
---
# AZ-802 Bereich 6 – Windows Server absichern (10–15 %)

Kapitel: [[AZ-802 Übersicht]] · Zurück: [[AZ-802 5 Speicher und Dateidienste]] · Weiter: [[AZ-802 7 Überwachung und Problembehandlung]]
Vorwissen: [[Gruppenrichtlinien]] · [[PKI und Zertifikatdienste]] · [[Kerberos]] · [[NTLM]] · [[LAPS]]

## Prüfungsziele (Checkliste)
**Betriebssystem**
- [ ] Exploit-Schutz
- [ ] [[App Control for Business]] (früher WDAC)
- [ ] [[Credential Guard]]
- [ ] Microsoft Defender SmartScreen
- [ ] OS-Sicherheit per Gruppenrichtlinie
- [ ] Sicherheitsbaseline mit [[OSConfig]]
- [ ] Windows [[LAPS]]
- [ ] [[Defender for Servers]]
- [ ] Windows-Firewall inkl. Verbindungssicherheitsregeln

**AD DS**
- [ ] Kennwortrichtlinien (inkl. Fine-Grained)
- [ ] [[Entra-Kennwortschutz]] für AD DS
- [ ] [[Protected Users]]
- [ ] DCs härten und Zugriff einschränken
- [ ] Sicherheitsoptionen für Benutzerkonten
- [ ] Integrierte Admin-Gruppen absichern
- [ ] AD-Delegierung
- [ ] Authentifizierungsprotokolle (Kerberos/NTLM)

## 1. Betriebssystem härten
| Funktion | Schutz gegen | Steuerung |
|---|---|---|
| Exploit-Schutz | Speicherangriffe (DEP, ASLR, CFG) systemweit/pro Programm | Windows-Sicherheit, XML per GPO, `Set-ProcessMitigation` |
| [[App Control for Business]] | nicht freigegebene Programme/Treiber (Positivliste, Kernel-Ebene) | Richtlinie (XML → binär), Überwachungsmodus zuerst; AppLocker = einfachere, ältere Alternative |
| [[Credential Guard]] | Diebstahl von Hashes/Tickets (Pass-the-Hash) | VBS; **Server 2025 standardmäßig an** (Domänenmitglieder, nicht DCs) |
| SmartScreen | schädliche Downloads/Websites | GPO *Windows Defender SmartScreen* |
| [[OSConfig]] | Abweichung von der Sicherheitsbaseline | PowerShell-Modul, Server 2025, verhindert Drift |
| [[LAPS]] | gleiches lokales Admin-Kennwort überall | Windows LAPS, Kennwort im AD oder Entra ID, automatisch rotiert |
| [[Defender for Servers]] | Malware, Schwachstellen, Angriffe | Defender for Cloud, Plan 1/2, lokal über [[Azure Arc]] |

```powershell
# Maschine: EXA-SRV01 (Server 2025) – Sicherheitsbaseline mit OSConfig
Install-Module -Name Microsoft.OSConfig -Scope AllUsers -Repository PSGallery -Force
Set-OSConfigDesiredConfiguration -Scenario SecurityBaseline/WS2025/MemberServer -Default
Get-OSConfigDesiredConfiguration -Scenario SecurityBaseline/WS2025/MemberServer |
  Format-Table Name, @{n='Status';e={$_.Compliance.Status}}
```
```powershell
# Maschine: EXA-DC01 – Windows LAPS
Update-LapsADSchema
Set-LapsADComputerSelfPermission -Identity 'OU=Server,DC=example,DC=com'
# GPO: Computerkonfiguration → Administrative Vorlagen → System → LAPS → Kennwortsicherungsverzeichnis = Active Directory
Get-LapsADPassword -Identity EXA-SRV01 -AsPlainText
Reset-LapsPassword            # auf dem Zielserver: sofort neues Kennwort
```

### Windows-Firewall
- Profile **Domäne / Privat / Öffentlich**; Regeln ein-/ausgehend; per GPO verteilen.
- **Verbindungssicherheitsregeln** = IPsec: Authentifizierung (Kerberos/Zertifikat) und ggf. Verschlüsselung zwischen Servern; Typen *Isolierung*, *Authentifizierungsausnahme*, *Server-zu-Server*, *Tunnel*.
```powershell
# Maschine: EXA-SRV01
New-NetFirewallRule -DisplayName 'RDP nur Admin-Netz' -Direction Inbound -Protocol TCP -LocalPort 3389 -RemoteAddress 192.168.50.0/24 -Action Allow
New-NetIPsecRule -DisplayName 'Isolierung SQL' -InboundSecurity Require -OutboundSecurity Request -RemoteAddress 192.168.1.221
Get-NetFirewallProfile | Format-Table Name, Enabled, DefaultInboundAction
```

## 2. AD DS absichern
### Kennwörter
| Mittel | Gilt für | Hinweis |
|---|---|---|
| Kennwortrichtlinie in der **Default Domain Policy** | alle Domänenkonten | nur **eine** pro Domäne (GPO auf Domänenebene) |
| **Fine-Grained Password Policy (PSO)** | Benutzer/globale Gruppen | Rangfolge (*Precedence*) – kleinere Zahl gewinnt |
| [[Entra-Kennwortschutz]] | lokale Kennwortänderungen | globale + eigene **Sperrliste**; DC-Agent + Proxy-Dienst; erst Überwachungs-, dann Erzwingungsmodus |
```powershell
# Maschine: EXA-DC01 – strengere Regel für Admins
New-ADFineGrainedPasswordPolicy -Name PSO-Admins -Precedence 10 -MinPasswordLength 16 `
  -ComplexityEnabled $true -LockoutThreshold 5 -MaxPasswordAge 90.00:00:00
Add-ADFineGrainedPasswordPolicySubject PSO-Admins -Subjects 'Domänen-Admins'
Get-ADUserResultantPasswordPolicy admin.sven
```

### Konten und Gruppen
| Maßnahme | Wirkung |
|---|---|
| [[Protected Users]] | kein NTLM, keine Delegierung, kein DES/RC4, keine zwischengespeicherten Anmeldedaten, TGT 4 h – **nicht** für Dienstkonten |
| „Konto ist vertraulich und kann nicht delegiert werden“ | Admin-Konten nicht delegierbar |
| „Smartcard ist für interaktive Anmeldung erforderlich“ | starke Anmeldung |
| Integrierte Gruppen (Schema-, Organisations-, Domänen-Admins; Konten-, Server-, Sicherungs-, Druck-Operatoren) | möglichst **leer**, nur zeitweise befüllen; Mitgliedschaft überwachen |
| Getrennte Admin-Konten + Tier-Modell | Tier 0 (DCs, AD) / Tier 1 (Server) / Tier 2 (Clients) – Admins melden sich nie „nach unten“ an |
| Authentifizierungsrichtlinien und -silos | Tier-0-Konten nur an bestimmten Systemen |

### DCs härten
- Nur DC-Rollen auf DCs (kein Web, keine Fremdsoftware), Server Core bevorzugen.
- Anmeldung per GPO beschränken (*Lokal anmelden verweigern* / *Anmelden über RDP* nur Tier-0).
- Physisch bzw. in Azure: Zugriff über [[Azure Bastion]]/PAW, keine öffentlichen IPs.
- **DSRM-Kennwort** pflegen ([[DSRM]]), Sicherungen schützen, LDAP-Signatur + Kanalbindung erzwingen, SMB-Signatur.

### AD-Delegierung
- **Assistent zum Zuweisen der Objektverwaltung** auf einer [[OU]] (z. B. Helpdesk: Kennwörter zurücksetzen).
- Prüfen/setzen auf Kommandozeile: `dsacls`.
```powershell
# Maschine: EXA-DC01 – Helpdesk darf Kennwörter in OU Benutzer zurücksetzen
dsacls 'OU=Benutzer,DC=example,DC=com' /I:S /G 'EXAMPLE\GG_Helpdesk:CA;Reset Password;user'
```

### Authentifizierungsprotokolle
- **Kerberos** mit AES bevorzugen, RC4/DES abschalten.
- **NTLM** erst überwachen (GPO *Netzwerksicherheit: NTLM einschränken – eingehenden NTLM-Verkehr überwachen*), dann einschränken; NTLMv1 und LM aus.
- Zeit synchron halten (Kerberos toleriert **5 Minuten**) → [[W32Time]].

## Fallen
- Protected Users bricht Dienste, die NTLM oder Delegierung brauchen → vorher testen.
- Nur **eine** Domänen-Kennwortrichtlinie per GPO – Ausnahmen nur per PSO.
- App Control erst im **Überwachungsmodus** testen, sonst startet ggf. nichts mehr.
- Credential Guard bricht CredSSP-Szenarien (z. B. [[Hyper-V Livemigration]]).

## Glossar
[[App Control for Business]] · [[Credential Guard]] · [[OSConfig]] · [[LAPS]] · [[Defender for Servers]] · [[Entra-Kennwortschutz]] · [[Protected Users]] · [[DSRM]] · [[Kerberos]] · [[NTLM]] · [[W32Time]] · [[OU]]
