---
typ: wissen
thema: Windows Server
tags: [windows-server, speicher, storage-spaces]
aliases: [Storage Spaces, Speicherplätze, Speicherpool]
quelle: Schulfolien „Speicherpools“ + Speicherpool.txt
status: lernen
---
# Speicherpools

Thema: [[Windows Server]] · Hardware: [[Netzteile und Schnittstellen]] · Glossar: [[RAID]] · [[SAN]] · [[NAS]] · [[iSCSI]] · [[ReFS]]

## Prinzip
Physische Datenträger → **Speicherpool** → **virtueller Datenträger** → Volume/Laufwerk
(Nach Installation existiert der Pool **Primordial** = alle freien Platten.)

| Layout | min. Platten | entspricht etwa |
|---|---|---|
| Einfach (Simple) | 1 | RAID 0 |
| Zwei-Wege-Spiegel | 2 | RAID 1 |
| Parität | 3 | RAID 5 |
| Drei-Wege-Spiegel | 5 | – |

| Bereitstellung | Eigenschaft |
|---|---|
| **Dünn (Thin)** | belegt nur Genutztes, Überbuchung möglich |
| **Fest (Fixed)** | sofort reserviert, bessere Leistung |

- Platten müssen leer/unformatiert sein; eine Platte gehört zu genau einem Pool
- **Hot-Spare**: springt bei Ausfall ein
- Mehrstufig (Tiering): HDD + SSD, häufige Daten auf SSD
- Bei Plattenfehler **kein chkdsk** → Platte tauschen, `Repair-VirtualDisk`

## Befehle
**Maschine: EXA-SRV01** (PowerShell als Admin)
```powershell
Get-PhysicalDisk -CanPool $true
New-StoragePool -FriendlyName myPool1 -StorageSubSystemFriendlyName "Windows Storage*" -PhysicalDisks (Get-PhysicalDisk -CanPool $true)
New-VirtualDisk -StoragePoolFriendlyName myPool1 -FriendlyName myVDisk4 -ResiliencySettingName Parity -Size 20GB -ProvisioningType Thin
Get-VirtualDisk | Get-PhysicalDisk
Get-PhysicalDisk | Where-Object HealthStatus -ne "Healthy"
```

> [!question] Selbsttest
> Du hast 3 Platten à 50 GB im Parity-Layout. Wie viel nutzbarer Platz entsteht ungefähr – und wie viele Platten dürfen ausfallen?

Mehr: [Microsoft Learn – Storage Spaces bereitstellen](https://learn.microsoft.com/de-de/windows-server/storage/storage-spaces/deploy-standalone-storage-spaces)

## 📄 Unterlagen
- Folien: [[Speicherpool.pdf#page=2|Überblick]] · [[Speicherpool.pdf#page=3|Tiering/Cache]] · [[Speicherpool.pdf#page=4|Pool erstellen]] · [[Speicherpool.pdf#page=5|Optionen]] · [[Speicherpool.pdf#page=6|Sektorgröße]] · [[Speicherpool.pdf#page=7|Laufwerkszuordnung]] · [[Speicherpool.pdf#page=8|Thin/Fest]] · [[Speicherpool.pdf#page=10|PowerShell]]
- Buch 70-740: [[70-740_Server2016_Installation_Speicher.pdf#page=154|Speicherpools]] · [[70-740_Server2016_Installation_Speicher.pdf#page=157|Layouts]] · [[70-740_Server2016_Installation_Speicher.pdf#page=164|Mehrstufig]] · [[70-740_Server2016_Installation_Speicher.pdf#page=166|iSCSI]] · [[70-740_Server2016_Installation_Speicher.pdf#page=414|Direkte Speicherplätze]]
