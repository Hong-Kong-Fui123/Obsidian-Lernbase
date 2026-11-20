---
tags: [az-802, loesung, az-802/monitoring]
bereich: 07
---
# Lab 07 Überwachung & Troubleshooting – Lösungen
↑ [[AZ-802 Lab 07 Troubleshooting - Aufgaben]]

### A1
```powershell
# EXA-SRV01
logman create counter Baseline -c "\Processor(_Total)\% Processor Time" "\Memory\Available MBytes" "\PhysicalDisk(_Total)\Avg. Disk sec/Read" "\Network Interface(*)\Bytes Total/sec" -si 00:00:15 -rf 01:00:00 -o C:\PerfLogs\Baseline
logman start Baseline
# Leistungswarnung: perfmon > Datensammlersätze > Benutzerdefiniert > Neu > Leistungsindikatorwarnung, Aktion "Eintrag im Anwendungsprotokoll"
```

### A2
- Collector-Computerkonto (bzw. Network Service) in **Event Log Readers** auf der Quelle; für Security-Log zusätzlich Kanal-SDDL bzw. Gruppe.
```powershell
# EXA-DC01
wecutil qc /q
# EXA-SRV01
winrm quickconfig -q
Add-LocalGroupMember "Event Log Readers" -Member "NT AUTHORITY\NETWORK SERVICE"
# GPO Quellen: Administrative Vorlagen > Windows-Komponenten > Ereignisweiterleitung > Zielabonnement-Manager:
#   Server=http://exa-dc01.example.com:5985/wsman/SubscriptionManager/WEC,Refresh=60
```

### A3
- Portal: Monitor → Datensammlungsregeln → Neu → Ressource EXA-SRV01 (Arc) → Datenquellen: Leistungsindikatoren, Windows-Ereignisprotokolle (XPath `Security!*[System[(EventID=4625)]]`) → Ziel Arbeitsbereich.
- Warnung: Arbeitsbereich → Protokolle → Abfrage → *Neue Warnungsregel*, Schwellenwert > 5, Zeitraum 5 Min.
```kusto
Event | where EventID == 4625 | summarize count() by bin(TimeGenerated, 5m), Computer
```

### A4
- Benutzer brauchen ihren Elterncontainer → erst OU.
```powershell
# EXA-DC01
Enable-ADOptionalFeature "Recycle Bin Feature" -Scope ForestOrConfigurationSet -Target example.com
Set-ADOrganizationalUnit "OU=Test,DC=example,DC=com" -ProtectedFromAccidentalDeletion $false
Remove-ADOrganizationalUnit "OU=Test,DC=example,DC=com" -Recursive -Confirm:$false
Get-ADObject -Filter 'Name -like "Test*"' -IncludeDeletedObjects | Restore-ADObject
Get-ADObject -Filter 'lastKnownParent -eq "OU=Test,DC=example,DC=com"' -IncludeDeletedObjects | Restore-ADObject
```

### A5
```powershell
# EXA-DC02
Install-WindowsFeature Windows-Server-Backup
wbadmin start systemstatebackup -backupTarget:E: -quiet
# Benutzer löschen, Replikation abwarten, dann DSRM:
bcdedit /set safeboot dsrepair; Restart-Computer
# im DSRM (Anmeldung .\Administrator mit DSRM-Kennwort)
wbadmin get versions
wbadmin start systemstaterecovery -version:<Version> -quiet
ntdsutil "activate instance ntds" "authoritative restore" "restore object CN=Max Muster,OU=Benutzer,DC=example,DC=com" q q
bcdedit /deletevalue safeboot; Restart-Computer
```

### A6
```powershell
# EXA-DC01
repadmin /replsummary
repadmin /showrepl EXA-DC02          # zeigt "inbound replication disabled"
repadmin /options EXA-DC02 -DISABLE_INBOUND_REPL
repadmin /syncall /AeD
# EXA-CL01 – Zeit
w32tm /query /status
w32tm /resync /force
# Nachweis: Ereignis Kerberos 4771 Fehlercode 0x25 (KRB_AP_ERR_SKEW) auf DC bzw. Systemprotokoll Client
```

### A7
```powershell
# EXA-CL01 (lokal als Administrator oder mit gecachter Anmeldung)
Test-ComputerSecureChannel                       # False
Test-ComputerSecureChannel -Repair -Credential EXAMPLE\Administrator
# Alternative
Reset-ComputerMachinePassword -Server EXA-DC01 -Credential EXAMPLE\Administrator
nltest /sc_verify:example.com
```

### A8
```powershell
# EXA-SRV02
Stop-Service wuauserv, bits, cryptsvc -Force
Rename-Item C:\Windows\SoftwareDistribution SoftwareDistribution.old
Start-Service wuauserv, bits, cryptsvc
DISM /Online /Cleanup-Image /RestoreHealth; sfc /scannow
Get-WindowsUpdateLog
# Speicher: Datenträger am Hyper-V-Host entfernen, dann
Get-PhysicalDisk | ? OperationalStatus -ne OK
Repair-VirtualDisk VD1
Get-StorageJob
```
