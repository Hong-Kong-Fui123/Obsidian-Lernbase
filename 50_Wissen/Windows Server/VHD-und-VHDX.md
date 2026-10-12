---
title: VHD und VHDX
aliases: [VHD, VHDX, virtuelle Festplatte, Virtual Hard Disk]
tags: [hyper-v, storage, windows-server, az-802, fisi]
modul: Windows Server Selbstlernmodul
status: lernen
erstellt: 2026-10-09
---

# VHD und VHDX

> [!info] Kontext
> Gehört zu [[Hyper-V Grundlagen]] · Voraussetzung für [[Generation 1 vs Generation 2 VM]] · genutzt bei [[Checkpoints (Hyper-V)]] und [[Failover-Cluster]]
> Prüfungsrelevant: [[AZ-802 Übersicht]]

## 1. Kernaussagen
- Virtuelle Festplatte = **eine Datei** auf dem Host, die der VM als physische Disk erscheint.
- **VHD** = Altformat (Virtual PC / Server 2008). **VHDX** = Standard ab Server 2012.
- Gen-2-VMs booten **nur von VHDX**.

## 2. Vergleich

| Merkmal                   | VHD                        | VHDX                                      |
| ------------------------- | -------------------------- | ----------------------------------------- |
| Max. Größe                | 2040 GB (~2 TB)            | 64 TB                                     |
| Sektorgröße               | 512 Byte                   | 512 Byte / 4 KB (logisch)                 |
| Schutz bei Stromausfall   | nein                       | ja (internes **Log**)                     |
| Online-Resize             | nein                       | ja (an SCSI-Controller)                   |
| [TRIM]/[UNMAP]            | nein                       | ja                                        |
| Boot in Gen-2-VM          | nein                       | ja                                        |
| Kompatibilität            | Azure (Upload), Altsysteme | ab Server 2012 / Win 8                    |
| Shared Disk (Gastcluster) | –                          | Shared VHDX → **VHD Set (.vhds)** ab 2016 |

> [!warning] Azure-Fallstrick
> Uploads nach Azure verlangen **VHD, feste Größe**. Lokal VHDX → vor Upload `Convert-VHD`. Siehe [[Azure Migrate]].

## 3. Disk-Typen

| Typ | Verhalten | Einsatz |
|---|---|---|
| **Fixed** (fest) | Volle Größe sofort belegt | Produktion, Performance, Azure |
| **Dynamic** (dynamisch) | Wächst bei Bedarf | Lab, Platz sparen |
| **Differencing** (differenzierend) | Speichert nur Änderungen ggü. **Parent** | Golden Image, [[Checkpoints (Hyper-V)]] (`.avhdx`) |

Alternative ohne Datei: **Pass-through-Disk** (physische Disk direkt an VM) → kaum noch genutzt, keine Checkpoints.

> [!danger] Differencing
> Parent-Disk **niemals** ändern oder verschieben → alle Child-Disks werden unbrauchbar. Parent schreibgeschützt setzen.

## 4. PowerShell (Modul `Hyper-V`)
**Maschine: Hyper-V-Host (Home-Lab)**, PowerShell als Admin

```powershell
# Dynamische VHDX erstellen
New-VHD -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx' -SizeBytes 60GB -Dynamic

# Feste VHDX
New-VHD -Path 'D:\Hyper-V\Disks\EXA-WEB01-Data.vhdx' -SizeBytes 20GB -Fixed

# Differencing-Disk aus Golden Image
New-VHD -Path 'D:\Hyper-V\Disks\EXA-DC02.vhdx' -ParentPath 'D:\Hyper-V\Base\WS2025-Base.vhdx' -Differencing

# Infos anzeigen
Get-VHD -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx'

# An VM anhängen (SCSI)
Add-VMHardDiskDrive -VMName 'EXA-DB01' -ControllerType SCSI -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx'

# Vergrößern (online bei VHDX an SCSI möglich)
Resize-VHD -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx' -SizeBytes 80GB

# Konvertieren (VM muss AUS sein)
Convert-VHD -Path 'D:\Hyper-V\Disks\alt.vhd' -DestinationPath 'D:\Hyper-V\Disks\neu.vhdx'

# Dynamische Disk verkleinern (VM aus oder Disk read-only gemountet)
Optimize-VHD -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx' -Mode Full

# Differencing-Kette zusammenführen
Merge-VHD -Path 'D:\Hyper-V\Disks\EXA-DC02.vhdx' -DestinationPath 'D:\Hyper-V\Base\WS2025-Base.vhdx'

# Integrität prüfen
Test-VHD -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx'

# Auf dem Host mounten / trennen
Mount-VHD   -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx'
Dismount-VHD -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx'
```

**Maschine: EXA-DB01** (nach Anhängen, neue Disk initialisieren)
```powershell
Get-Disk | Where-Object PartitionStyle -eq 'RAW' |
  Initialize-Disk -PartitionStyle GPT -PassThru |
  New-Partition -AssignDriveLetter -UseMaximumSize |
  Format-Volume -FileSystem NTFS -NewFileSystemLabel 'Data' -Confirm:$false
```
→ Dateisystemwahl: [[NTFS vs ReFS]]

## 5. Aufgaben

### Aufgabe 1 – Verständnis
Eine VM soll per **UEFI/Secure Boot** starten. Welches Format brauchst du und warum?

> [!success]- Lösung
> VHDX. UEFI/Secure Boot = Gen-2-VM → bootet nur von VHDX.

### Aufgabe 2 – Szenario
Du willst 4 Lab-Server aus einem Server-2025-Image bauen, mit minimalem Platz. Welcher Disk-Typ, welche Gefahr?

> [!success]- Lösung
> Differencing-Disks mit gemeinsamer Parent (Golden Image, sysprep). Gefahr: Parent ändern → alle Childs kaputt. Parent schreibgeschützt setzen.

### Aufgabe 3 – Fehleranalyse
`Convert-VHD` bricht mit „in use“ ab. Ursache?

> [!success]- Lösung
> VM läuft noch bzw. Disk ist angehängt/gemountet. VM herunterfahren oder `Dismount-VHD`.

### Aufgabe 4 – Azure
Lokale VHDX (dynamisch, 50 GB) soll nach Azure. Was ist zu tun?

> [!success]- Lösung
> `Convert-VHD -VHDType Fixed` in eine `.vhd` konvertieren, Größe auf ganze MB ausrichten, dann hochladen.

### Aufgabe 5 – Praxis (Home-Lab)
Erstelle `EXA-DB01-Data.vhdx` (60 GB, dynamisch), hänge sie an EXA-DB01 an, formatiere sie als `D:`.

> [!success]- Lösung
> Siehe Abschnitt 4: `New-VHD` → `Add-VMHardDiskDrive` (Host) → `Initialize-Disk`-Pipeline (EXA-DB01).

## 6. Validierung
**Maschine: Hyper-V-Host (Home-Lab)**
```powershell
$p = 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx'
$v = Get-VHD -Path $p
[pscustomobject]@{
  Format    = $v.VhdFormat      # erwartet: VHDX
  Typ       = $v.VhdType        # erwartet: Dynamic
  GroesseGB = $v.Size / 1GB     # erwartet: 60
  Angehaengt= (Get-VMHardDiskDrive -VMName 'EXA-DB01').Path -contains $p
  OK        = Test-VHD -Path $p
}
```

## 7. Merksätze
- VHDX = Standard, VHD nur für Azure/Altsysteme.
- Fixed = Leistung, Dynamic = Platz, Differencing = Vorlagen + Checkpoints.
- Konvertieren nur offline, Resize online nur VHDX an SCSI.

## Verweise
- Intern: [[Hyper-V Grundlagen]] · [[Generation 1 vs Generation 2 VM]] · [[Checkpoints (Hyper-V)]] · [[Sysprep und Golden Image]] · [[NTFS vs ReFS]] · [[Storage Spaces]] · [[Failover-Cluster]] · [[Azure Migrate]] · [[AZ-802 Übersicht]]
- Extern:
  - [New-VHD (Microsoft Learn)](https://learn.microsoft.com/powershell/module/hyper-v/new-vhd)
  - [Convert-VHD (Microsoft Learn)](https://learn.microsoft.com/powershell/module/hyper-v/convert-vhd)
  - [Hyper-V Storage (Microsoft Learn)](https://learn.microsoft.com/windows-server/virtualization/hyper-v/)
