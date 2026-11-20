---
tags: [az-802, lab, az-802/sicherheit]
bereich: 06
umgebung: HL
maschinen: [EXA-DC01, EXA-SRV01, EXA-SRV02, EXA-CL01]
status: offen
---
# Lab 06 Sicherheit – Aufgaben
↑ [[AZ-802 06 Sicherheit]] · Lösungen: [[AZ-802 Lab 06 Sicherheit - Loesungen]]

### A1 – FGPP
**Maschine:** EXA-DC01
**Auftrag:** `GG_Admins`: min. 15 Zeichen, Sperre nach 5 Fehlversuchen, Precedence 10.
**Leitfrage:** Benutzer in zwei Gruppen mit PSO 10 und 20 – welche gilt?
**Validierung:** `Get-ADUserResultantPasswordPolicy <Admin-Benutzer>`

### A2 – Windows LAPS
**Maschinen:** EXA-DC01, EXA-SRV02
**Auftrag:** Schema erweitern, OU *Server* Selbst-Schreibrecht, GPO: Ziel AD, 14 Tage, Kennwort verschlüsselt, Leser `GG_IT`.
**Validierung (EXA-DC01):** `Get-LapsADPassword EXA-SRV02 -AsPlainText`

### A3 – Protected Users + Kontooptionen
**Maschine:** EXA-DC01
**Auftrag:** Admin-Testkonto in *Protected Users*, zusätzlich *Konto ist vertraulich*. NTLM-Anmeldung testen.
**Leitfrage:** Warum schlägt `net use \\<IP>\c$` fehl, `\\exa-srv01\c$` aber nicht?
**Validierung (EXA-CL01):** `klist` → Ticket-Lebensdauer 4 h

### A4 – Delegierung
**Maschine:** EXA-DC01
**Auftrag:** `GG_Helpdesk` darf in OU *Benutzer* nur Kennwörter zurücksetzen + Sperre aufheben.
**Validierung:** `dsacls "OU=Benutzer,DC=example,DC=com" | findstr Helpdesk`

### A5 – OS-Härtung
**Maschine:** EXA-SRV01
**Auftrag:** OSConfig-Baseline *MemberServer* anwenden; Credential Guard per GPO; WDAC-Richtlinie im Audit-Modus aus Standardvorlage; Exploit-Schutz-Einstellungen exportieren.
**Leitfrage:** Warum Audit-Modus vor Erzwingen?
**Validierung:** `Get-OSConfigDesiredConfiguration -Scenario SecurityBaseline/WS2025/MemberServer | ? Compliance -ne Compliant` · `msinfo32` → VBS-Dienste

### A6 – Firewall + IPsec
**Maschinen:** EXA-SRV01, EXA-SRV03
**Auftrag:** Regel: RDP nur aus `10.10.10.0/24`. Verbindungssicherheitsregel (Kerberos) zwischen beiden Servern, Authentifizierung anfordern → erzwingen.
**Validierung:** `Get-NetIPsecMainModeSA` zeigt SA nach Ping/SMB.
