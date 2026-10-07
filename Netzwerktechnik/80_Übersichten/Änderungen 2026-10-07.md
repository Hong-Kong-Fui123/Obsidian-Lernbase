---
typ: uebersicht
tags: [moc, log]
---
# Änderungen 2026-10-07 (Vault-Überarbeitung)

Zurück: [[Start]]

## PDFs eingebunden
- 37 PDFs nach `99_Anhänge/PDF/<Thema>/` (Dateinamen ohne Umlaute)
- [[PDF-Index]]: jede Folie/Seite einzeln verlinkt, Bücher mit Kapiteln
- Jede Fachnotiz hat jetzt einen Abschnitt **📄 Unterlagen** mit Seitenlinks
- Bücher (110 MB) in `.gitignore` → werden **nicht** nach GitHub gepusht (zu Hause separat kopieren oder Zeile in `.gitignore` löschen)
- `user.csv`, `user.ldf` → `99_Anhänge/Dateien/AD/`

## 00_Inbox einsortiert
| Inhalt aus `Notizen.md` | Neue Notiz |
|---|---|
| RADIUS | [[RADIUS und NPS]] |
| Zertifikat ohne CA, Sperrliste abschalten | [[Lab VPN SSTP mit MS-CHAPv2]] |
| DNS vs. mDNS | [[DNS vs mDNS]] |

## Neue Wissensnotizen (aus den Schul-PDFs)
[[AD DS Überblick]] · [[AD-Gruppen und AGDLP]] · [[Gruppenrichtlinien]] · [[Vertrauensstellungen]] · [[PKI und Zertifikatdienste]] · [[DHCP-Server]] · [[PowerShell Grundlagen]] · [[Speicherpools]] · [[Reverse-Lookup-Zone]]

## Aufgeräumt
- Kaputte Dateinamen (`LÃ¶sung…`, `├£bungsklausuren…`) repariert
- `# Forward-Lookup-Zone.md` → [[Glossar/Forward-Lookup-Zone]] (`#` im Namen bricht Links)
- `C# Grundlagen` → [[CSharp Grundlagen]] (Alias „C# Grundlagen“ bleibt)
- Ordner **Übungsklausuren** gelöscht = 1:1-Kopie der Theorieklausuren (dein Häkchen in Klausur 2 übernommen)
- Leere Dateien gelöscht: `202610061208`, `Fibre - Channel`, `OSI-Modell`, `Glossar/Unbenannt`, 4× `Unbenannt*.canvas`, `Unbenannt.base`, 3 leere Excalidraw-Zeichnungen
- Doppelte Wurzel-Stubs `DNS-Records.md`, `Forward-Lookup-Zone.md` entfernt
- `Vorlagen/` → `90_Vorlagen/` (Templater-Ordner war schon 90_Vorlagen)
- `Glossar-Verlinken.ps1` → `99_Anhänge/Skripte/` (Skip-Ordner angepasst)
- Glossar: [[Fibre Channel]], [[IQN]], [[iSNS - Server]] neu/formatiert, 51 Einträge mit „Mehr:“-Links

## Verweise geprüft
- Vorher **24** kaputte Links → jetzt **0** (inkl. Überschrift-Anker und PDF-Seitenzahlen)
- `Snapshot-States`, `Firewall-Regeln` → Abschnitte in [[VM-Infrastruktur]]
- `Andrew Warren: Zertifikate` → [[70-742_Server2016_Identitaet.pdf#page=291|70-742 Kap. 4]]
- Noch **nicht erstellt** (als Text markiert ⏳): Lösung_02_CA-Serverrolle · Aufgabe_03_CA-Troubleshooting · Theorie-Zusammenfassung Woche 05

## Inhaltlich korrigiert (Korrektur-Boxen eingearbeitet)
- [[IT - Netzwerkwissen]]: Klasse E 240–255, `slmgr -dli` = Lizenz, nicht Lease
- [[Netzwerkbefehle und DHCP]]: `ipconfig /all`, `arp -d`, APIPA 169.254.0.0/16
- [[Mainboard und Prozessor]]: Unix-Zeit, Sockel/Pins, TPM, Tjmax
- [[SQL - Befehle und Abfragen]]: `DATEPART`; [[SQL - Isolation, Dateien, Partitionen, Rechte]]: Write-Ahead Logging
- [[RADIUS und NPS]]: NAS = Network **Access** Server (vorher fälschlich auf Glossar NAS = Storage verlinkt)
- [[Lab VPN SSTP mit MS-CHAPv2]]: Hinweis `LocalMachine\My` statt `CurrentUser\My`

## Nicht angefasst
- `GELLERnt.exe`, `Netzilon.exe` (139 MB) im Vault-Root – gehören eher nicht ins Git-Repo
- Aus `Windows.7z` nicht übernommen: `nanoserver.vhdx`, `7z2409-x64.msi`, `admintemplates_x64_*.exe`
