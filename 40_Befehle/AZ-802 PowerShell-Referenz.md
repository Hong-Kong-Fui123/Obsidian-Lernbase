---
aliases: [AZ-802 Befehle, AZ-802 Cmdlets]
tags: [az-802, befehle, powershell]
---
# AZ-802 PowerShell-Referenz
↑ [[AZ-802 MOC]]

## 01 AD DS
| Aufgabe | Befehl | Maschine |
|---|---|---|
| DC hinzufügen | `Install-ADDSDomainController -DomainName example.com -InstallDns` | neuer DC |
| FSMO anzeigen | `netdom query fsmo` | DC |
| FSMO verschieben / seize | `Move-ADDirectoryServerOperationMasterRole -Identity DC -OperationMasterRole PDCEmulator [-Force]` | DC |
| RODC-Konto vorbereiten | `Add-ADDSReadOnlyDomainControllerAccount` | DC |
| PRP | `Add-ADDomainControllerPasswordReplicationPolicy` | DC |
| Standort/Subnetz/Link | `New-ADReplicationSite` / `-Subnet` / `-SiteLink` | DC |
| Trusts | `Get-ADTrust -Filter *`, `nltest /domain_trusts` | DC |
| KDS-Key | `Add-KdsRootKey -EffectiveImmediately` | DC |
| gMSA | `New-ADServiceAccount` · `Install-/Test-ADServiceAccount` | DC / Mitglied |
| GPO | `New-GPO`, `New-GPLink`, `Get-GPResultantSetOfPolicy`, `gpresult /h r.html` | DC / Client |

## 02 Hybrid
| Aufgabe | Befehl | Maschine |
|---|---|---|
| Remoting an | `Enable-PSRemoting -Force` | Ziel |
| TrustedHosts | `Set-Item WSMan:\localhost\Client\TrustedHosts -Value srv` | Quelle |
| RBKCD | `Set-ADComputer Ziel -PrincipalsAllowedToDelegateToAccount (Get-ADComputer Quelle)` | DC |
| JEA | `New-PSRoleCapabilityFile`, `New-PSSessionConfigurationFile`, `Register-PSSessionConfiguration` | Ziel |
| SSH | `Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0` | Ziel |
| Arc-Status | `azcmagent show` / `azcmagent check` | Arc-Server |
| Arc-Erweiterung | `New-AzConnectedMachineExtension` | Cloud Shell |

## 03 VM
| Aufgabe | Befehl | Maschine |
|---|---|---|
| PS Direct | `Enter-PSSession -VMName X -Credential …` | Hyper-V-Host |
| Nested | `Set-VMProcessor X -ExposeVirtualizationExtensions $true` | Hyper-V-Host |
| Dyn. RAM | `Set-VMMemory X -DynamicMemoryEnabled $true -MinimumBytes … -MaximumBytes …` | Hyper-V-Host |
| Checkpoint | `Set-VM X -CheckpointType Production`, `Checkpoint-VM` | Hyper-V-Host |
| VHD | `New-VHD`, `Resize-VHD`, `Convert-VHD`, `Optimize-VHD` | Hyper-V-Host |
| vSwitch / NAT | `New-VMSwitch`, `New-NetNat` | Hyper-V-Host |
| SET | `New-VMSwitch -NetAdapterName A,B -EnableEmbeddedTeaming $true` | Hyper-V-Host |
| Teaming in VM | `Set-VMNetworkAdapter X -AllowTeaming On` | Hyper-V-Host |
| DDA | `Dismount-VMHostAssignableDevice`, `Add-VMAssignableDevice` | Hyper-V-Host |
| GPU-P | `Add-VMGpuPartitionAdapter` | Hyper-V-Host |
| Replikat | `Set-VMReplicationServer`, `Enable-VMReplication`, `Start-VMFailover -AsTest`, `Measure-VMReplication` | Hyper-V-Host |

## 04 Netzwerk
| Aufgabe | Befehl | Maschine |
|---|---|---|
| Zone | `Add-DnsServerPrimaryZone -Name x -ReplicationScope Forest` | DC |
| Eintrag | `Add-DnsServerResourceRecordA -CreatePtr` | DC |
| Bed. Weiterleitung | `Add-DnsServerConditionalForwarderZone` | DC |
| Richtlinie | `Add-DnsServerQueryResolutionPolicy` | DC |
| DNSSEC | `Invoke-DnsServerZoneSign -SignWithDefault` | DC |
| DHCP autorisieren | `Add-DhcpServerInDC` | DHCP |
| Bereich/Reservierung | `Add-DhcpServerv4Scope`, `Add-DhcpServerv4Reservation` | DHCP |
| Failover | `Add-DhcpServerv4Failover -ServerRole Active/Standby` oder `-LoadBalancePercent` | DHCP |

## 05 Speicher
| Aufgabe | Befehl | Maschine |
|---|---|---|
| Freigabe | `New-SmbShare`, `Grant-SmbShareAccess` | Dateiserver |
| FSRM | `New-FsrmQuota`, `New-FsrmFileScreen` | Dateiserver |
| DFS | `New-DfsnRoot`, `New-DfsReplicationGroup`, `Get-DfsrBacklog` | Dateiserver |
| SMB | `Set-SmbServerConfiguration`, `New-SmbServerCertificateMapping` | Dateiserver |
| Pool | `New-StoragePool`, `New-VirtualDisk -ResiliencySettingName Mirror/Parity` | Server |
| S2D | `Enable-ClusterStorageSpacesDirect` | Clusterknoten |
| Speicherreplikat | `Test-SRTopology`, `New-SRPartnership` | Server |
| Dedup | `Enable-DedupVolume`, `Start-DedupJob` | Server |
| QoS | `New-StorageQosPolicy -PolicyType Dedicated/Aggregated` | Cluster |
| iSCSI | `New-IscsiVirtualDisk`, `New-IscsiServerTarget`, `Connect-IscsiTarget` | Target / Initiator |
| BitLocker | `Enable-BitLocker`, `Backup-BitLockerKeyProtector`, `manage-bde -unlock` | Server |

## 06 Sicherheit
| Aufgabe | Befehl | Maschine |
|---|---|---|
| FGPP | `New-ADFineGrainedPasswordPolicy`, `Get-ADUserResultantPasswordPolicy` | DC |
| LAPS | `Update-LapsADSchema`, `Set-LapsADComputerSelfPermission`, `Get-LapsADPassword` | DC |
| OSConfig | `Set-OSConfigDesiredConfiguration -Scenario SecurityBaseline/WS2025/MemberServer -Default` | Server 2025 |
| WDAC | `New-CIPolicy`, `ConvertFrom-CIPolicy` | Server |
| Exploit-Schutz | `Get-/Set-ProcessMitigation` | Server |
| Firewall | `New-NetFirewallRule`, `New-NetIPsecRule` | Server |
| Delegierung prüfen | `dsacls "OU=…"` | DC |

## 07 Monitoring/Troubleshooting
| Aufgabe | Befehl | Maschine |
|---|---|---|
| Sammlersatz | `logman create counter …` | Server |
| Ereignisse | `Get-WinEvent -FilterHashtable @{LogName='System';Level=2}` | Server |
| WEF | `wecutil qc`, `winrm quickconfig` | Collector / Quelle |
| Netzwerk | `Test-NetConnection -Port`, `Resolve-DnsName` | alle |
| Zeit | `w32tm /query /status`, `/resync`, `/stripchart` | alle |
| Update | `Get-WindowsUpdateLog`, `DISM /Online /Cleanup-Image /RestoreHealth`, `sfc /scannow` | Server |
| AD-Papierkorb | `Enable-ADOptionalFeature 'Recycle Bin Feature'`, `Restore-ADObject` | DC |
| Replikation | `repadmin /replsummary`, `/showrepl`, `/syncall /AeD`, `dcdiag` | DC |
| Kerberos | `klist`, `klist purge`, `setspn -X` | Client / DC |
| Secure Channel | `Test-ComputerSecureChannel -Repair` | Client |
| Systemstatus | `wbadmin start systemstatebackup`, `ntdsutil "authoritative restore"` | DC |
