---
typ: wissen
thema: AZ-802
tags: [az-802, hyper-v, azure-vm, exam]
aliases: [AZ-802 Bereich 3, AZ-802 Hyper-V, Azure-VMs verwalten]
gewicht: "10–15 %"
erstellt: 2026-10-19
status: lernen
---
# AZ-802 Bereich 3 – Virtuelle Maschinen verwalten (10–15 %)

Kapitel: [[AZ-802 Übersicht]] · Zurück: [[AZ-802 2 Hybride Verwaltung]] · Weiter: [[AZ-802 4 Netzwerk DNS DHCP]]
Vorwissen: [[Hyper-V]] · [[50_Wissen/Windows Server/VHD-und-VHDX|VHD-und-VHDX]] · [[HyperV-VM-Export-Import]] · [[Hyper-V Livemigration]] · [[Failovercluster]]

## Prüfungsziele Hyper-V (Checkliste)
- [ ] [[Erweiterter Sitzungsmodus]] aktivieren
- [ ] VMs remote verwalten: PowerShell, [[PowerShell Direct]], SSH Direct (Linux-Gäste)
- [ ] [[Geschachtelte Virtualisierung]] aktivieren
- [ ] Arbeitsspeicher konfigurieren (dynamisch, NUMA)
- [ ] Integrationsdienste konfigurieren
- [ ] Gerätezuweisung ([[DDA]]) und [[GPU-P]]
- [ ] [[Checkpoint|Prüfpunkte]] verwalten
- [ ] Hochverfügbarkeit für VMs → [[Failovercluster]] · [[Hyper-V Livemigration]]
- [ ] Virtuelle Festplatten → [[50_Wissen/Windows Server/VHD-und-VHDX|VHD-und-VHDX]]
- [ ] Netzwerkadapter, NIC-Teaming (Host + VM), [[vSwitch]], [[SET]]
- [ ] [[Hyper-V-Replikat]]

## Prüfungsziele Azure-VMs (Checkliste)
- [ ] Speicher für Azure-VMs → [[Verwalteter Datenträger]]
- [ ] Kapazität: Größe ändern, [[VMSS|Skalierungsgruppen]]
- [ ] [[Verfügbarkeitsgruppe|Verfügbarkeitsgruppen]] und [[Verfügbarkeitszone|-zonen]]
- [ ] [[JIT-VM-Zugriff]] und [[Azure Bastion]]
- [ ] Netzwerkkonfiguration von Azure-VMs ([[VNet]], [[NSG]])

## 1. Hyper-V – Funktionen und Befehle
| Funktion | Zweck | Befehl (Maschine: Hyper-V-Host) |
|---|---|---|
| Erweiterter Sitzungsmodus | Zwischenablage, Laufwerke, Audio in der VM-Konsole (über RDP-Technik) | `Set-VMHost -EnableEnhancedSessionMode $true` |
| PowerShell Direct | PowerShell in die VM über **VMBus** – ohne Netzwerk, ohne Firewall | `Enter-PSSession -VMName EXA-WEB01 -Credential EXAMPLE\Administrator` |
| SSH Direct | SSH in Linux-Gast über VMBus (hv_sock) | `hvc ssh benutzer@<VM-Name>` |
| Geschachtelte Virtualisierung | Hyper-V **in** einer VM (Lab!) | `Set-VMProcessor -VMName EXA-HV01 -ExposeVirtualizationExtensions $true` (VM aus) + `Set-VMNetworkAdapter -VMName EXA-HV01 -MacAddressSpoofing On` |
| Dynamischer Arbeitsspeicher | RAM nach Bedarf zwischen Minimum und Maximum | `Set-VMMemory EXA-WEB01 -DynamicMemoryEnabled $true -MinimumBytes 1GB -StartupBytes 2GB -MaximumBytes 4GB` |
| Integrationsdienste | Herunterfahren, Zeitsync, Datenaustausch, Heartbeat, VSS, Gastdienste | `Enable-VMIntegrationService -VMName EXA-WEB01 -Name 'Guest Service Interface'` (dt. Host: *Gastdienstschnittstelle*) |
| DDA | physisches PCIe-Gerät (GPU, NVMe) **exklusiv** an eine VM | `Dismount-VMHostAssignableDevice` → `Add-VMAssignableDevice` |
| GPU-P | **eine** GPU in Partitionen für mehrere VMs (Server 2025: auch Livemigration/HA) | `Add-VMGpuPartitionAdapter -VMName EXA-WEB01` |
| Prüfpunkte | Standard (mit RAM-Zustand) vs. **Produktion** (VSS im Gast, Standard) | `Set-VM EXA-WEB01 -CheckpointType Production` · `Checkpoint-VM` |

> [!tip] Lab-Bezug
> Für Livemigration, Replikat und Cluster im Home-Lab: zwei Hyper-V-**VMs** (z. B. EXA-HV01/HV02) mit geschachtelter Virtualisierung auf dem physischen Host.

### Netzwerk in Hyper-V
| Thema | Kernpunkt |
|---|---|
| [[vSwitch]] | Extern / Intern / Privat |
| [[SET]] (Switch Embedded Teaming) | Teaming **im** vSwitch, empfohlen; klassisches LBFO-Teaming wird für Hyper-V-Switches nicht mehr empfohlen |
| NIC-Teaming in der VM | nur mit 2 vNICs an **verschiedenen** externen Switches, `Set-VMNetworkAdapter -AllowTeaming On` |
| Erweiterte Adapterfunktionen | VLAN-ID, MAC-Spoofing, DHCP-/Router-Wächter, Bandbreite, VMQ/SR-IOV |
```powershell
# Maschine: Hyper-V-Host – SET-Switch aus zwei physischen Karten
New-VMSwitch -Name SETswitch -NetAdapterName 'NIC1','NIC2' -EnableEmbeddedTeaming $true -AllowManagementOS $true
Set-VMNetworkAdapterVlan -VMName EXA-WEB01 -Access -VlanId 20
```

### Hyper-V-Replikat
- Asynchrone Kopie einer VM auf einen **zweiten Host/Standort** (Notfallwiederherstellung, kein HA).
- Replikationsintervall **30 s, 5 Min. oder 15 Min.**; zusätzliche Wiederherstellungspunkte; Authentifizierung Kerberos (HTTP 80) oder Zertifikat (HTTPS 443).
- Failover-Arten: **Testfailover** (Kopie, Produktion läuft weiter), **geplantes Failover** (Primär aus, kein Datenverlust), **ungeplantes Failover** (Primär weg).
- Im Cluster: Rolle **Hyper-V-Replikatbroker**.
```powershell
# Maschine: EXA-HV02 (Replikatserver)
Set-VMReplicationServer -ReplicationEnabled $true -AllowedAuthenticationType Kerberos `
  -ReplicationAllowedFromAnyServer $true -DefaultStorageLocation D:\Replikat
# Maschine: EXA-HV01 (primär)
Enable-VMReplication -VMName EXA-WEB01 -ReplicaServerName EXA-HV02 -ReplicaServerPort 80 -AuthenticationType Kerberos -ReplicationFrequencySec 300
Start-VMInitialReplication -VMName EXA-WEB01
Measure-VMReplication
```

## 2. Azure-VMs
### Speicher
| Datenträger | Merkmal |
|---|---|
| Betriebssystemdatenträger | C:, verwalteter Datenträger |
| Temporärer Datenträger | meist **D:**, lokal am Host, **geht bei Neuzuordnung verloren** – nur Auslagerungsdatei/Temp |
| Datenträger für Daten | eigene [[Verwalteter Datenträger\|verwaltete Datenträger]], Cache-Einstellung je Datenträger |

Typen: Standard-HDD → Standard-SSD → **Premium-SSD** (v2) → Ultra Disk. Größe nur **vergrößern**, nicht verkleinern. Verschlüsselung: serverseitig standardmäßig; zusätzlich Azure Disk Encryption (BitLocker im Gast) oder Verschlüsselung auf dem Host.

### Kapazität
- **Größe ändern:** Portal → Größe; Neustart; ist die Größe im aktuellen Hardwarecluster nicht verfügbar → VM vorher **beenden (Zuordnung aufheben)**.
- **[[VMSS]]** (Skalierungsgruppen): viele gleiche VMs, **Autoskalierung** nach Metrik (z. B. CPU > 70 % → +1 Instanz) oder Zeitplan; Orchestrierung *Flexibel* (Standard) oder *Einheitlich*.

### Verfügbarkeit
| Option | Schutz gegen | SLA (Konnektivität) |
|---|---|---|
| Einzel-VM mit Premium-SSD/Ultra | – | 99,9 % |
| [[Verfügbarkeitsgruppe]] | Ausfall eines Racks (Fehlerdomänen, max. 3) + Wartung (Updatedomänen, max. 20) | 99,95 % |
| [[Verfügbarkeitszone\|Verfügbarkeitszonen]] | Ausfall eines ganzen Rechenzentrums | 99,99 % |
Verfügbarkeitsgruppe/Zone nur **beim Erstellen** wählbar.

### Sicherer Zugriff
| Lösung | Wie | Vorteil |
|---|---|---|
| [[Azure Bastion]] | RDP/SSH im Browser über das Portal (HTTPS 443), eigenes Subnetz **AzureBastionSubnet** | VM braucht **keine öffentliche IP** |
| [[JIT-VM-Zugriff]] | Defender for Cloud öffnet NSG-Port (z. B. 3389) **nur auf Anfrage**, nur für Quell-IP, zeitlich begrenzt | kleine Angriffsfläche |

### Netzwerk
- Jede VM hat mindestens eine NIC in einem Subnetz eines [[VNet]]; private IP dynamisch oder **statisch (in Azure)**.
- [[NSG]] an NIC oder Subnetz: Regeln mit Priorität 100–4096, niedrigere Zahl gewinnt; Standardregeln erlauben VNet-intern, blocken Internet eingehend.
- Beschleunigter Netzwerkbetrieb (SR-IOV), mehrere NICs (je nach Größe), öffentliche IP optional.
- Diagnose: Network Watcher → *IP-Flussüberprüfung*, *effektive Sicherheitsregeln*, *nächster Hop*.

```powershell
# Maschine: Admin-PC (Az-Modul)
Get-AzVM -ResourceGroupName rg-az802-lab -Status | Format-Table Name, PowerState, Location
Stop-AzVM -ResourceGroupName rg-az802-lab -Name vm-az802 -Force            # Zuordnung aufheben → keine Compute-Kosten
$vm = Get-AzVM -ResourceGroupName rg-az802-lab -Name vm-az802
$vm.HardwareProfile.VmSize = 'Standard_D2s_v5'; Update-AzVM -VM $vm -ResourceGroupName rg-az802-lab
```

## Fallen
- Temporärer Datenträger ≠ Datendatenträger – keine Daten auf D: speichern.
- Herunterfahren **im Gast** stoppt die Abrechnung nicht – im Portal „Beenden“.
- PowerShell Direct funktioniert nur **auf dem Host** der VM und braucht Anmeldedaten **des Gastes**.
- Replikat ist keine Hochverfügbarkeit: Umschalten ist manuell und kann Daten seit dem letzten Intervall verlieren.

## Glossar
[[Hyper-V]] · [[Erweiterter Sitzungsmodus]] · [[PowerShell Direct]] · [[Geschachtelte Virtualisierung]] · [[DDA]] · [[GPU-P]] · [[SET]] · [[Hyper-V-Replikat]] · [[Checkpoint]] · [[Verwalteter Datenträger]] · [[VMSS]] · [[Verfügbarkeitsgruppe]] · [[Verfügbarkeitszone]] · [[Azure Bastion]] · [[JIT-VM-Zugriff]] · [[VNet]] · [[NSG]] · [[SLA]]
