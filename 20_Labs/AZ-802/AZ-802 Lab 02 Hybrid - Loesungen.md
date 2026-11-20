---
tags: [az-802, loesung, az-802/hybrid]
bereich: 02
---
# Lab 02 Hybrid – Lösungen
↑ [[AZ-802 Lab 02 Hybrid - Aufgaben]]

### A1
- CA-Zertifikat: vertraut in der Domäne, kein 60-Tage-Ablauf, Übung für PKI-Modul.
- Ablauf: Zertifikat anfordern (`certlm.msc` auf EXA-SRV01, SAN `exa-srv01.example.com`) → Thumbprint → WAC-Installer (MSI) mit eigenem Zertifikat, Port 443.
```powershell
# EXA-SRV01
Get-ChildItem Cert:\LocalMachine\My | ft Subject,Thumbprint,NotAfter
```

### A2
- RBKCD am **Ziel** (Ressource): EXA-SRV03 erlaubt EXA-SRV01.
```powershell
# EXA-DC01
Set-ADComputer EXA-SRV03 -PrincipalsAllowedToDelegateToAccount (Get-ADComputer EXA-SRV01)
Get-ADComputer EXA-SRV03 -Properties PrincipalsAllowedToDelegateToAccount
# EXA-SRV01 – Ticket-Cache leeren
klist purge -li 0x3e7
```

### A3
- Virtuelles Konto: lokaler Admin während der Sitzung, Benutzer selbst bleibt unprivilegiert, kein Kennwort zu verwalten.
```powershell
# EXA-DC01
$mod = "C:\Program Files\WindowsPowerShell\Modules\JEA-DNS"
New-Item "$mod\RoleCapabilities" -ItemType Directory -Force
New-ModuleManifest "$mod\JEA-DNS.psd1"
New-PSRoleCapabilityFile -Path "$mod\RoleCapabilities\DnsOps.psrc" `
  -VisibleCmdlets 'Get-DnsServerResourceRecord','Add-DnsServerResourceRecordA',@{Name='Restart-Service';Parameters=@{Name='Name';ValidateSet='DNS'}}
New-PSSessionConfigurationFile -Path C:\JEA\DnsOps.pssc -SessionType RestrictedRemoteServer `
  -RunAsVirtualAccount -TranscriptDirectory C:\JEA\Transcripts -RoleDefinitions @{'EXAMPLE\GG_DnsOps'=@{RoleCapabilities='DnsOps'}}
Register-PSSessionConfiguration -Name DnsOps -Path C:\JEA\DnsOps.pssc
```

### A4
```powershell
# EXA-SRV03
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Set-Service sshd -StartupType Automatic; Start-Service sshd
# EXA-CL01
ssh-keygen -t ed25519
# Public Key in EXA-SRV03: C:\ProgramData\ssh\administrators_authorized_keys
# ACL nur SYSTEM + Administrators:
icacls C:\ProgramData\ssh\administrators_authorized_keys /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
# sshd_config: PasswordAuthentication no → Restart-Service sshd
```

### A5
- Nur ausgehend **443** (+ Azure-Endpunkte). Zeitabweichung → Token-Fehler, Agent verbindet nicht.
- Portal: Azure Arc → Computer → Hinzufügen → Einzelner Server → Skript generieren → auf EXA-SRV01 ausführen.
```powershell
# EXA-SRV01
azcmagent show
azcmagent check
# Cloud Shell
New-AzConnectedMachineExtension -ResourceGroupName rg-az802-lab -MachineName EXA-SRV01 -Location westeurope `
  -Name AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ExtensionType AzureMonitorWindowsAgent
```

### A6
- Portal: Azure Update Manager → Maschinen → EXA-SRV01 → *Periodische Bewertung* an → Wartungskonfiguration (Guest), Klassifizierung *Kritisch, Sicherheit*.
- Runbook: Automation-Konto → Identität (systemzugewiesen) an → Rolle *Virtual Machine Contributor* auf `rg-az802-lab`.
```powershell
# Runbook-Inhalt
Connect-AzAccount -Identity
Get-AzVM -ResourceGroupName rg-az802-lab | Stop-AzVM -Force
```
