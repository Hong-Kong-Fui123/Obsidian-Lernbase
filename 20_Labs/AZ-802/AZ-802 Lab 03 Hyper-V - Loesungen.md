---
tags: [az-802, loesung, az-802/vm]
bereich: 03
---
# Lab 03 Hyper-V – Lösungen
↑ [[AZ-802 Lab 03 Hyper-V - Aufgaben]]

### A1
- **Gast**-Anmeldedaten.
```powershell
# Hyper-V-Host
$c = Get-Credential EXAMPLE\Administrator
Disconnect-VMNetworkAdapter -VMName EXA-SRV02
Invoke-Command -VMName EXA-SRV02 -Credential $c { Get-NetIPConfiguration }
$s = New-PSSession -VMName EXA-SRV02 -Credential $c
Copy-Item .\test.txt -Destination C:\Temp\ -ToSession $s
Connect-VMNetworkAdapter -VMName EXA-SRV02 -SwitchName <Switch>
```

### A2
```powershell
# Hyper-V-Host (VM aus!)
Stop-VM EXA-TEST01
Set-VMProcessor EXA-TEST01 -ExposeVirtualizationExtensions $true
Set-VMMemory EXA-TEST01 -DynamicMemoryEnabled $false -StartupBytes 4GB
Get-VMNetworkAdapter EXA-TEST01 | Set-VMNetworkAdapter -MacAddressSpoofing On
Start-VM EXA-TEST01
# EXA-TEST01
Install-WindowsFeature Hyper-V -IncludeManagementTools -Restart
```

### A3
- *Production only*: Checkpoint schlägt fehl, kein Fallback auf Standard.
```powershell
# Hyper-V-Host (dyn. RAM-Wechsel: VM aus)
Set-VMMemory EXA-SRV02 -DynamicMemoryEnabled $true -MinimumBytes 1GB -StartupBytes 2GB -MaximumBytes 4GB
Enable-VMIntegrationService -VMName EXA-SRV02 -Name "Guest Service Interface"
Set-VM EXA-SRV02 -CheckpointType ProductionOnly
Checkpoint-VM EXA-SRV02 -SnapshotName vor-Lab03
```

### A4
- Änderung am Parent zerstört alle Children (Blockreferenzen ungültig).
```powershell
# Hyper-V-Host
New-VHD -Path D:\VMs\EXA-TEST01.vhdx -ParentPath D:\Parent\WS2025-sysprep.vhdx -Differencing
New-VHD -Path D:\VMs\EXA-SRV02-Data.vhdx -SizeBytes 20GB -Dynamic
Add-VMHardDiskDrive EXA-SRV02 -ControllerType SCSI -Path D:\VMs\EXA-SRV02-Data.vhdx
Resize-VHD D:\VMs\EXA-SRV02-Data.vhdx -SizeBytes 30GB
# EXA-SRV02
Resize-Partition -DriveLetter E -Size (Get-PartitionSupportedSize -DriveLetter E).SizeMax
```

### A5
```powershell
# Hyper-V-Host
New-VMSwitch -Name LabNAT -SwitchType Internal
New-NetIPAddress -IPAddress 192.168.100.1 -PrefixLength 24 -InterfaceAlias "vEthernet (LabNAT)"
New-NetNat -Name LabNAT -InternalIPInterfaceAddressPrefix 192.168.100.0/24
Add-VMNetworkAdapter EXA-SRV01 -SwitchName LabNAT -Name NAT
Set-VMNetworkAdapterVlan -VMName EXA-SRV01 -VMNetworkAdapterName NAT -Access -VlanId 20   # VLAN nur Übung, bei NAT wieder entfernen
# SET (Theorie)
New-VMSwitch -Name SETswitch -NetAdapterName "NIC1","NIC2" -EnableEmbeddedTeaming $true
```
- EXA-SRV01: IP `192.168.100.10/24`, GW `.1`, DNS `EXA-DC01` (der leitet weiter).

### A6
- Kerberos braucht gemeinsame Vertrauensbasis; sonst **Zertifikat/HTTPS 443**.
```powershell
# Zielhost (G15)
Set-VMReplicationServer -ReplicationEnabled $true -AllowedAuthenticationType Kerberos -ReplicationAllowedFromAnyServer $true -DefaultStorageLocation D:\Replica
Enable-NetFirewallRule -DisplayName "Hyper-V Replica HTTP Listener (TCP-In)"
# Quellhost
Enable-VMReplication EXA-TEST01 -ReplicaServerName <G15-FQDN> -ReplicaServerPort 80 -AuthenticationType Kerberos -ReplicationFrequencySec 300 -RecoveryHistory 4
Start-VMInitialReplication EXA-TEST01
# Zielhost – Testfailover
Start-VMFailover -VMName EXA-TEST01 -AsTest
Measure-VMReplication
```
> Hinweis: Home-Lab-Hosts sind nicht in example.com → in der Praxis Zertifikat-Variante wählen oder Kerberos nur theoretisch.

### A7
- Availability Set nur bei Erstellung zuweisbar, und Set + Zone schließen sich aus.
```powershell
# Cloud Shell
New-AzResourceGroup rg-az802-lab -Location westeurope
# Portal: VM erstellen → Zone 1, Public-IP: Keine, Datendisk Premium SSD
$vm = Get-AzVM -Name az-srv01 -ResourceGroupName rg-az802-lab
$vm.HardwareProfile.VmSize = "Standard_B2ms"; Update-AzVM -VM $vm -ResourceGroupName rg-az802-lab
Remove-AzResourceGroup rg-az802-lab -Force
```
