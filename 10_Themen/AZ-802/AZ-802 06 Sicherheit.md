---
aliases: [Sicherheit AZ-802, Härtung]
tags: [az-802, az-802/sicherheit, thema]
bereich: 06
gewicht: 10–15 %
status: offen
---
# 06 Windows-Server-Infrastruktur sichern (10–15 %)
↑ [[AZ-802 MOC]] · Lab: [[AZ-802 Lab 06 Sicherheit - Aufgaben]]

## Prüfungsziele
**OS:** Exploit-Schutz · App Control for Business (WDAC) · Credential Guard · SmartScreen · Sicherheit per GPO · Baselines mit OSConfig · Windows LAPS · Defender for Servers · Firewall + Verbindungssicherheitsregeln
**AD DS:** Kennwortrichtlinien · Entra-Kennwortschutz · Protected Users · DC-Härtung · DC-Zugriff einschränken · Kontooptionen · integrierte Admin-Gruppen · Delegierung · Authentifizierungsprotokolle

## Betriebssystem
| Funktion | Kern | Werkzeug |
|---|---|---|
| Exploit-Schutz | DEP, ASLR, CFG – systemweit/pro App | Windows-Sicherheit, `Set-ProcessMitigation`, XML via GPO |
| App Control for Business (WDAC) | Kernel-Positivliste; Audit-Modus zuerst | `New-CIPolicy`, `ConvertFrom-CIPolicy` |
| AppLocker | Benutzerbasierte Regeln (älter), Dienst *AppIDSvc* | GPO |
| Credential Guard | VBS isoliert LSA-Geheimnisse (NTLM-Hash, Kerberos-TGT) | GPO *Device Guard*, UEFI + Secure Boot |
| SmartScreen | Reputationsprüfung Downloads/Apps | GPO |
| OSConfig | Sicherheitsbaseline für Server 2025 anwenden + Drift korrigieren | `Set-OSConfigDesiredConfiguration -Scenario SecurityBaseline/WS2025/MemberServer -Default` |
| Windows LAPS | lokales Admin-Kennwort rotieren, in **AD DS oder Entra ID**, verschlüsselt möglich, DSRM-Konto für DCs | `Update-LapsADSchema`, `Set-LapsADComputerSelfPermission`, `Get-LapsADPassword` |
| Defender for Servers | Teil Defender for Cloud, Plan 1 (MDE) / Plan 2 (+JIT, FIM, Schwachstellen) | Arc für on-prem |
| Firewall | Profile Domäne/Privat/Öffentlich; Verbindungssicherheitsregeln = **IPsec** (Isolation, Server-zu-Server, Tunnel, Authentifizierungsausnahme) | `New-NetFirewallRule`, `New-NetIPsecRule` |

## AD DS
| Thema | Merkpunkt |
|---|---|
| Kennwortrichtlinie Domäne | **nur eine** in Default Domain Policy |
| Fein abgestimmt (FGPP/PSO) | auf Benutzer/globale Gruppen, **Precedence** niedrig gewinnt, `New-ADFineGrainedPasswordPolicy` |
| Entra-Kennwortschutz | gesperrte Kennwortliste (global + benutzerdef.) on-prem: **Proxy-Dienst** + **DC-Agent**, Audit/Erzwingen |
| Protected Users | kein NTLM, kein DES/RC4, keine Delegierung, TGT 4 h, kein Cache → nicht für Dienstkonten |
| DC-Härtung | Server Core, nur DC-Rollen, kein Internet, Updates, LDAP-Signierung + Channel Binding, SMB-Signierung, Tier-0 |
| DC-Zugriff einschränken | GPO *Lokal anmelden zulassen*, PAW, Authentifizierungsrichtlinien + **Silos** |
| Kontooptionen | *Konto ist vertraulich, kann nicht delegiert werden*, Smartcard erforderlich, Kerberos AES |
| Admin-Gruppen | Enterprise/Schema/Domain Admins leer halten, **AdminSDHolder**/SDProp (60 Min), Account/Server/Backup Operators meiden |
| Delegierung | Assistent *Objektverwaltung zuweisen* auf OU, `dsacls` zur Prüfung |
| Authentifizierung | Kerberos (88) > NTLM; NTLM auditieren/einschränken, NTLMv1 aus, RC4 ablösen |

## Prüfungsfallen
- FGPP **nicht** auf OUs.
- Protected Users wirkt erst ab DC 2012 R2+ voll und bricht NTLM-Apps.
- WDAC zuerst im **Audit-Modus**.
- Legacy LAPS ≠ Windows LAPS (eingebaut seit April 2023).
- Verbindungssicherheitsregel ≠ Firewall-Regel (IPsec-Authentifizierung).

## Leitfragen
1. Admins brauchen 15-stellige Kennwörter, alle anderen 10. Wie?
2. Warum gehört ein gMSA nicht in Protected Users?
3. Was verhindert Credential Guard – und was nicht (Keylogger)?

## Glossar
[[Windows LAPS]] · [[Credential Guard]] · [[WDAC]] · [[Protected Users]] · [[FGPP]] · [[AdminSDHolder]] · [[OSConfig]]
