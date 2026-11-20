---
tags: [az-802, lab, az-802/hybrid]
bereich: 02
umgebung: HL + HY
maschinen: [EXA-SRV01, EXA-SRV03, EXA-CL01, EXA-DC01, Azure-Portal]
status: offen
---
# Lab 02 Hybrid – Aufgaben
↑ [[AZ-802 02 Hybrid-Verwaltung]] · Lösungen: [[AZ-802 Lab 02 Hybrid - Loesungen]]

> [!warning] A4–A6 brauchen Internet für EXA-SRV01 (NAT-Switch, siehe Lab 03 A5) + Azure-Abo. Ressourcengruppe `rg-az802-lab`.

### A1 – WAC-Gateway
**Maschine:** EXA-SRV01
**Auftrag:** Windows Admin Center als Gateway installieren, Zertifikat aus deiner Enterprise CA (Vorlage *Web Server*) binden, EXA-DC01 hinzufügen.
**Leitfrage:** Warum lieber CA-Zertifikat statt selbstsigniert?
**Validierung (EXA-CL01):** Browser `https://exa-srv01.example.com` ohne Zertifikatswarnung.

### A2 – Double-Hop
**Maschinen:** EXA-CL01 → EXA-SRV01 → EXA-SRV03
**Auftrag:** Fehler reproduzieren (`dir \\EXA-SRV03\c$` in Remote-Sitzung), dann per RBKCD lösen.
**Leitfrage:** Auf welchem Objekt wird RBKCD eingetragen – Quelle oder Ziel?
**Validierung (EXA-CL01):** `Invoke-Command EXA-SRV01 { dir \\EXA-SRV03\c$ }` ohne Fehler (nach `klist purge -li 0x3e7` auf EXA-SRV01).

### A3 – JEA DNS-Operator
**Maschine:** EXA-DC01
**Auftrag:** JEA-Endpunkt `DnsOps`: Gruppe `GG_DnsOps` darf nur `Get-DnsServerResourceRecord`, `Add-DnsServerResourceRecordA`, `Restart-Service -Name DNS`.
**Leitfrage:** Warum `RunAsVirtualAccount`?
**Validierung (EXA-CL01):** `Enter-PSSession EXA-DC01 -ConfigurationName DnsOps` → `Get-Command` zeigt nur erlaubte Befehle.

### A4 – SSH
**Maschine:** EXA-SRV03 · Client EXA-CL01
**Auftrag:** OpenSSH-Server installieren, Schlüsselauthentifizierung für Domänen-Admin, Kennwort-Login deaktivieren.
**Validierung (EXA-CL01):** `ssh example\administrator@exa-srv03` ohne Kennwortabfrage.

### A5 – Azure Arc + Erweiterung
**Maschine:** EXA-SRV01 · Azure-Portal
**Auftrag:** EXA-SRV01 Arc-fähig machen, Azure Monitor Agent als Erweiterung installieren, Tag `Umgebung=Lab`.
**Leitfragen:** Welche Ports? Was passiert bei Zeitabweichung?
**Validierung (EXA-SRV01):** `azcmagent show` → Status *Connected*.

### A6 – Update Manager + Runbook
**Maschine:** Azure-Portal · EXA-SRV01
**Auftrag:** Periodische Bewertung aktivieren, Wartungskonfiguration *Sa 02:00*, nur Sicherheitsupdates. Runbook `Stop-LabVMs` mit verwalteter Identität, das alle VMs in `rg-az802-lab` stoppt.
**Validierung (Cloud Shell):** `Get-AzMaintenanceConfiguration -ResourceGroupName rg-az802-lab`
