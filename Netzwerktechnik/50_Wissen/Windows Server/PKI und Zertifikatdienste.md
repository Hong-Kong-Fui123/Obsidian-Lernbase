---
typ: wissen
thema: Windows Server
tags: [windows-server, pki, ad-cs, zertifikate]
aliases: [PKI Grundlagen, AD CS Grundlagen, Zertifikate]
quelle: Schulfolien „Zertifikate“ + Übung CA installieren
status: lernen
---
# PKI und Zertifikatdienste

Thema: [[Windows Server]] · Glossar: [[PKI]] · [[AD CS]] · [[CA]] · [[CRL]] · [[CDP]] · [[AIA]] · [[OCSP]] · [[X.509]] · [[CSR]]
Labs: [[Aufgabe_01_PKI-Grundlagen]] · [[Aufgabe_02_CA-Serverrolle]] · [[Klausur_Zertifikate_120Min]] · [[Praxisklausur 2 - PKI Zertifikate]] · [[Lab VPN SSTP mit MS-CHAPv2]]

## Ziele sicherer Kommunikation
**Vertraulichkeit** (Verschlüsselung) · **Integrität** (Hash/Signatur) · **Authentizität** (Zertifikat) → [[CIA]]

## Verfahren
| | Symmetrisch | Asymmetrisch |
|---|---|---|
| Schlüssel | 1 gemeinsamer | Public + Private Key |
| Beispiele | DES, 3DES, [[AES]], RC4 | [[RSA]], DSA, Diffie-Hellman |
| Vorteil | schnell | kein Schlüsselaustausch nötig |
| Nachteil | Schlüsselaustausch riskant | ca. 1000× langsamer |
**Praxis (TLS):** asymmetrisch den Sitzungsschlüssel aushandeln → symmetrisch verschlüsseln.

**Digitale Signatur:** Hash ([[SHA]]) der Nachricht mit **privatem** Schlüssel des Absenders verschlüsseln → Empfänger prüft mit **öffentlichem** Schlüssel.

## CA-Typen
| | Unternehmens-CA (Enterprise) | Eigenständige CA (Standalone) |
|---|---|---|
| AD nötig | ja | nein (kann offline) |
| Vorlagen / Autoenrollment | ja | nein, Anträge manuell genehmigen |
| Typisch | Sub-CA online | **Root-CA offline** |

**Sperrung:** Basissperrliste (alle) + Deltasperrliste (seit letzter Basis) → über **CDP** veröffentlicht; CA-Zertifikat über **AIA**.

## Autoenrollment (GPO)
`Computerkonfiguration\Richtlinien\Windows-Einstellungen\Sicherheitseinstellungen\Richtlinien für öffentliche Schlüssel` → *Zertifikatdienstclient – Automatische Registrierung* = **Aktiviert** (+ Häkchen Erneuern/Aktualisieren). Vorlage: Berechtigung **Registrieren + Automatisch registrieren** für die Gruppe.

**Prüfen** – Maschine: EXA-CL01 (PowerShell)
```powershell
certutil -pulse                       # Autoenrollment sofort auslösen
Get-ChildItem Cert:\LocalMachine\My | Select-Object Subject, Issuer, NotAfter
certutil -verify -urlfetch C:\temp\client.cer   # Kette, CDP, AIA prüfen
```

> [!question] Selbsttest
> Warum stellt man die Root-CA als **eigenständige** CA auf und schaltet sie danach aus – was passiert, wenn ihre CRL abläuft?

## 📄 Unterlagen
- Folien „Zertifikate“: [[AD-Zertifikatdienste.pdf#page=2|Ziele]] · [[AD-Zertifikatdienste.pdf#page=3|Symmetrisch]] · [[AD-Zertifikatdienste.pdf#page=5|Asymmetrisch]] · [[AD-Zertifikatdienste.pdf#page=8|Vor-/Nachteile]] · [[AD-Zertifikatdienste.pdf#page=10|Digitale Signatur]] · [[AD-Zertifikatdienste.pdf#page=13|PKI]] · [[AD-Zertifikatdienste.pdf#page=14|Inhalt Zertifikat]] · [[AD-Zertifikatdienste.pdf#page=15|Aufgaben CA]] · [[AD-Zertifikatdienste.pdf#page=16|CA installieren]] · [[AD-Zertifikatdienste.pdf#page=18|Vorlagen]] · [[AD-Zertifikatdienste.pdf#page=20|Vorlagen-Berechtigungen]] · [[AD-Zertifikatdienste.pdf#page=21|Autoenrollment]]
- Übung: [[Uebung_Zertifizierungsstellen_installieren.pdf#page=1|CA installieren: Stamm + Sub-CA]] · [[Uebung_Zertifizierungsstellen_installieren.pdf#page=2|Eigenständige CA]] · [[Uebung_Zertifizierungsstellen_installieren.pdf#page=3|CDP/AIA]]
- Buch 70-742 (Andrew Warren): [[70-742_Server2016_Identitaet.pdf#page=291|Kap. 4 AD CS]] · [[70-742_Server2016_Identitaet.pdf#page=293|Eigenständig vs. Unternehmen]] · [[70-742_Server2016_Identitaet.pdf#page=307|Offline-CA]] · [[70-742_Server2016_Identitaet.pdf#page=325|OCSP]] · [[70-742_Server2016_Identitaet.pdf#page=334|Vorlagen]] · [[70-742_Server2016_Identitaet.pdf#page=342|Sperren]]
- Buch 70-640: [[70-640_Server2008R2_AD.pdf#page=837|Kap. 15 AD CS und PKI]]
- Prüfungsfragen: [[AD-CS_20_Pruefungsfragen.pdf#page=1|AD CS 20]] · [[AD-CS_20_Pruefungsfragen.pdf#page=5|Szenarien]] · [[AD-CS_20_Pruefungsfragen.pdf#page=8|Lösungen]]
