---
tags: [az-802, loesung, az-802/speicher]
bereich: 05
---
# Lab 05 Speicher – Lösungen
↑ [[AZ-802 Lab 05 Speicher - Aufgaben]]

### A1
- 3 Kopien → **45 GB** Rohkapazität (thin: erst bei Belegung).
```powershell
# Hyper-V-Host
1..5 | % { New-VHD "D:\VMs\SRV02-S$_.vhdx" -SizeBytes 10GB -Dynamic | Out-Null; Add-VMHardDiskDrive EXA-SRV02 -ControllerType SCSI -Path "D:\VMs\SRV02-S$_.vhdx" }
# EXA-SRV02
$d = Get-PhysicalDisk -CanPool $true
New-StoragePool -FriendlyName Pool1 -StorageSubSystemFriendlyName "Windows Storage*" -PhysicalDisks $d
New-VirtualDisk -StoragePoolFriendlyName Pool1 -FriendlyName VD1 -ResiliencySettingName Mirror -NumberOfDataCopies 3 -Size 15GB -ProvisioningType Thin
Get-VirtualDisk VD1 | Get-Disk | Initialize-Disk -PassThru | New-Partition -DriveLetter S -UseMaximumSize | Format-Volume -FileSystem ReFS
```

### A2
```powershell
# EXA-SRV03
Install-WindowsFeature FS-iSCSITarget-Server
New-IscsiVirtualDisk -Path D:\iSCSI\LUN1.vhdx -SizeBytes 5GB
New-IscsiServerTarget -TargetName SRV02 -InitiatorIds "IQN:iqn.1991-05.com.microsoft:exa-srv02.example.com"
Add-IscsiVirtualDiskTargetMapping -TargetName SRV02 -Path D:\iSCSI\LUN1.vhdx
Set-IscsiServerTarget -TargetName SRV02 -EnableChap $true -Chap (Get-Credential chapuser)   # Secret 12–16 Zeichen
# EXA-SRV02
Start-Service MSiSCSI; Set-Service MSiSCSI -StartupType Automatic
New-IscsiTargetPortal -TargetPortalAddress exa-srv03
Connect-IscsiTarget -NodeAddress (Get-IscsiTarget).NodeAddress -AuthenticationType ONEWAYCHAP -ChapUsername chapuser -ChapSecret <Secret> -IsPersistent $true
```

### A3
- GPO: *BitLocker-Laufwerkverschlüsselung > Festplattenlaufwerke > Wiederherstellung … festlegen* → „BitLocker erst aktivieren, wenn Wiederherstellungsinformationen in AD DS gespeichert sind“.
```powershell
# EXA-SRV02
Install-WindowsFeature FS-Data-Deduplication, BitLocker -IncludeManagementTools -Restart
Enable-DedupVolume S: -UsageType Default; Start-DedupJob S: -Type Optimization
Enable-BitLocker -MountPoint E: -PasswordProtector -Password (Read-Host -AsSecureString)
Add-BitLockerKeyProtector -MountPoint E: -RecoveryPasswordProtector
$id = (Get-BitLockerVolume E:).KeyProtector | ? KeyProtectorType -eq RecoveryPassword
Backup-BitLockerKeyProtector -MountPoint E: -KeyProtectorId $id.KeyProtectorId
Lock-BitLocker E: -ForceDismount
manage-bde -unlock E: -RecoveryPassword <48-stellig>
```

### A4
- Effektiv übers Netz: **Ändern** (restriktiver gewinnt).
```powershell
# EXA-SRV03
Install-WindowsFeature FS-Resource-Manager -IncludeManagementTools
New-SmbShare -Name IT -Path D:\IT -ChangeAccess "EXAMPLE\DL_Share_IT_RW" -FolderEnumerationMode AccessBased
New-FsrmQuota -Path D:\IT -Size 2GB
New-FsrmFileScreen -Path D:\IT -IncludeGroup "Audio and Video Files" -Active
```

### A5
```powershell
# EXA-SRV02 + EXA-SRV03
Install-WindowsFeature FS-DFS-Namespace, FS-DFS-Replication -IncludeManagementTools
# EXA-SRV02
New-DfsnRoot -Path \\example.com\Daten -TargetPath \\EXA-SRV02\Daten -Type DomainV2
New-DfsnFolder -Path \\example.com\Daten\IT -TargetPath \\EXA-SRV02\IT
New-DfsnFolderTarget -Path \\example.com\Daten\IT -TargetPath \\EXA-SRV03\IT
New-DfsReplicationGroup IT-RG | New-DfsReplicatedFolder -FolderName IT | Add-DfsrMember -ComputerName EXA-SRV02,EXA-SRV03
Add-DfsrConnection -GroupName IT-RG -SourceComputerName EXA-SRV02 -DestinationComputerName EXA-SRV03
Set-DfsrMembership -GroupName IT-RG -FolderName IT -ComputerName EXA-SRV02 -ContentPath D:\IT -PrimaryMember $true -Force
Set-DfsrMembership -GroupName IT-RG -FolderName IT -ComputerName EXA-SRV03 -ContentPath D:\IT -Force
```

### A6
```powershell
# EXA-SRV03
Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
Set-SmbServerConfiguration -EnableSMB1Protocol $false -RequireSecuritySignature $true -Force
Set-SmbShare -Name IT -EncryptData $true -Force
# QUIC (Zertifikat mit SAN exa-srv03.example.com, Server-Auth-EKU)
New-SmbServerCertificateMapping -Name exa-srv03.example.com -Thumbprint <Thumbprint> -StoreName My
# Client-Zugriff: net use \\exa-srv03.example.com\IT /TRANSPORT:QUIC
```

### A7
- Viele Provider blockieren **TCP 445** ausgehend → VPN, SMB über QUIC (Azure File Sync-Server als Cache) oder File Sync nutzen.
- Ablauf Portal: Storage-Konto → Dateifreigabe → *Speichersynchronisierungsdienst* erstellen → Agent auf EXA-SRV03 (MSI), Server registrieren → Sync-Gruppe (Cloudendpunkt `itsync`) → Serverendpunkt `D:\IT`, Cloud-Tiering an, Volume-Freiraum 30 %.
```powershell
# EXA-SRV03
Import-Module "C:\Program Files\Azure\StorageSyncAgent\StorageSync.Management.ServerCmdlets.dll"
Get-StorageSyncHeatStoreInformation -VolumePath D:\
```
