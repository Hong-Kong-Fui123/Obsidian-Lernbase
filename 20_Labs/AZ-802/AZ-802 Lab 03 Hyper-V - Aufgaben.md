---
tags: [az-802, lab, az-802/vm]
bereich: 03
umgebung: HL + AZ
maschinen: [Hyper-V-Host, EXA-SRV01, EXA-SRV02, EXA-TEST01, Azure-Portal]
status: offen
---
# Lab 03 Hyper-V – Aufgaben
↑ [[AZ-802 03 Virtuelle Computer]] · Lösungen: [[AZ-802 Lab 03 Hyper-V - Loesungen]]

### A1 – PowerShell Direct
**Maschine:** Hyper-V-Host
**Auftrag:** Netzwerkadapter von EXA-SRV02 trennen, dann per PowerShell Direct IP-Konfiguration abfragen und Datei `C:\Temp\test.txt` in die VM kopieren.
**Leitfrage:** Welche Anmeldedaten brauchst du – Host oder Gast?
**Validierung:** `Invoke-Command -VMName EXA-SRV02 { Test-Path C:\Temp\test.txt }`

### A2 – Nested Virtualization
**Maschine:** Hyper-V-Host → EXA-TEST01
**Auftrag:** EXA-TEST01 für Hyper-V-im-Gast vorbereiten und Rolle installieren.
**Validierung (EXA-TEST01):** `Get-WindowsFeature Hyper-V` → Installed

### A3 – Speicher, Integration, Prüfpunkte
**Maschine:** Hyper-V-Host
**Auftrag:** EXA-SRV02: dyn. RAM 1–4 GB, Start 2 GB; Gastdienste an; Prüfpunkttyp *Production only*; Checkpoint `vor-Lab03`.
**Leitfrage:** Was passiert bei *Production only*, wenn VSS im Gast fehlschlägt?
**Validierung:** `Get-VM EXA-SRV02 | fl DynamicMemoryEnabled,CheckpointType`

### A4 – Festplatten
**Maschine:** Hyper-V-Host
**Auftrag:** Differenzierende Disk für EXA-TEST01 auf Basis einer sysprepped Parent-VHDX. Daten-VHDX 20 GB (dynamisch) online an EXA-SRV02 hängen und auf 30 GB erweitern.
**Leitfrage:** Warum muss die Parent-Disk schreibgeschützt bleiben?
**Validierung:** `Get-VHD <Pfad> | ft VhdType,Size,ParentPath`

### A5 – vSwitch NAT + SET + VLAN
**Maschine:** Hyper-V-Host
**Auftrag:** Interner Switch `LabNAT` mit NAT `192.168.100.0/24` (Internet für Arc-Labs). Zweiter Adapter für EXA-SRV01 mit VLAN 20. Theorie: SET-Befehl für 2 physische NICs notieren.
**Validierung (EXA-SRV01):** `Test-NetConnection www.microsoft.com -Port 443`

### A6 – Hyper-V-Replikat
**Maschinen:** Hyper-V-Host (Desktop) → Dell G15 (Server 2025 + Hyper-V)
**Auftrag:** EXA-TEST01 mit Kerberos/HTTP replizieren, Intervall 5 Min, 4 Wiederherstellungspunkte, danach Testfailover.
**Leitfrage:** Warum funktioniert Kerberos nur, wenn beide Hosts in einer Domäne sind?
**Validierung:** `Measure-VMReplication`

### A7 – Azure-VM
**Maschine:** Azure-Portal / Cloud Shell
**Auftrag:** Windows-Server-VM `az-srv01` in Zone 1 ohne Public-IP, Datendisk Premium SSD, Zugriff per Bastion (Developer-SKU), danach Größe ändern. Am Ende Ressourcengruppe löschen.
**Leitfrage:** Warum kann die VM nicht nachträglich in ein Availability Set?
**Validierung (Cloud Shell):** `Get-AzVM -Name az-srv01 -ResourceGroupName rg-az802-lab | fl Zones,HardwareProfile`
