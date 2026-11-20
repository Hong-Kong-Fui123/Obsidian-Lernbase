---
tags: [az-802, lab, az-802/monitoring]
bereich: 07
umgebung: HL + HY
maschinen: [EXA-DC01, EXA-DC02, EXA-SRV01, EXA-CL01, Azure-Portal]
status: offen
---
# Lab 07 Überwachung & Troubleshooting – Aufgaben
↑ [[AZ-802 07 Ueberwachung und Troubleshooting]] · Lösungen: [[AZ-802 Lab 07 Troubleshooting - Loesungen]]

> [!tip] Fehler bewusst einbauen, dann ohne Lösung finden. Checkpoints!

### A1 – Datensammlersatz + Warnung
**Maschine:** EXA-SRV01
**Auftrag:** Sammlersatz `Baseline` (CPU, RAM, Disk, Netz, 15 s, 1 h). Leistungswarnung bei CPU > 85 % → Ereignis schreiben.
**Validierung:** `logman query`

### A2 – Ereignisweiterleitung
**Maschinen:** EXA-DC01 (Collector), EXA-SRV01 (Quelle)
**Auftrag:** Abonnement für Sicherheits-Ereignis 4625 (quellinitiiert per GPO).
**Leitfrage:** Welche Gruppe braucht das Computerkonto des Collectors auf der Quelle für Security-Log?
**Validierung (EXA-DC01):** *Weitergeleitete Ereignisse* enthält 4625 nach Fehlanmeldung.

### A3 – Azure Monitor (Arc)
**Maschine:** Azure-Portal · EXA-SRV01 (Arc aus Lab 02)
**Auftrag:** Log-Analytics-Arbeitsbereich, DCR (Perf + System-Fehler + 4625), Protokollwarnung bei > 5 × 4625 in 5 Min → Aktionsgruppe Mail. VM Insights aktivieren.
**Validierung:** KQL `Event | where EventID == 4625 | take 10`

### A4 – AD-Papierkorb
**Maschine:** EXA-DC01
**Auftrag:** Papierkorb aktivieren, OU *Test* mit 3 Benutzern löschen (Löschschutz vorher entfernen!), wiederherstellen inkl. Benutzer.
**Leitfrage:** Warum zuerst die OU, dann die Benutzer?
**Validierung:** `Get-ADUser -SearchBase "OU=Test,DC=example,DC=com" -Filter *`

### A5 – Autoritative Wiederherstellung
**Maschinen:** EXA-DC01, EXA-DC02
**Auftrag:** Systemstatus-Backup EXA-DC02 (Windows Server-Sicherung), Benutzer löschen, Wiederherstellung autoritativ über DSRM ohne Papierkorb-Nutzung.
**Validierung:** Benutzer auf EXA-DC01 nach Replikation vorhanden, `repadmin /showobjmeta` Version erhöht.

### A6 – Replikation + Zeit + Kerberos
**Maschinen:** EXA-DC01, EXA-DC02, EXA-CL01
**Auftrag:**
1. Replikation gezielt stoppen (`repadmin /options EXA-DC02 +DISABLE_INBOUND_REPL`), Fehler finden, beheben.
2. Uhr EXA-CL01 um 10 Min verstellen (Zeitsync aus), Anmeldung testen, Ursache nachweisen.
**Validierung:** `repadmin /replsummary` fehlerfrei · `w32tm /stripchart /computer:EXA-DC01 /samples:3`

### A7 – Secure Channel
**Maschine:** EXA-CL01
**Auftrag:** Checkpoint → Computerkonto im AD zurücksetzen → Anmeldung schlägt fehl → ohne Domänenaustritt reparieren.
**Validierung:** `Test-ComputerSecureChannel` → `True`

### A8 – Windows Update / Speicher (Mini-Fälle)
**Maschine:** EXA-SRV02
**Auftrag:** Update-Cache reparieren (Dienste, SoftwareDistribution), Systemdateien prüfen; Speicherplatz-Datenträger aus A1 Lab 05 entfernen und Pool reparieren.
**Validierung:** `Get-VirtualDisk | ft HealthStatus,OperationalStatus`
