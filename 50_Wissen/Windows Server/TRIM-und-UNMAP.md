---
title: TRIM und UNMAP
aliases: [TRIM, UNMAP, Deallocate, Speicherrückgewinnung, Space Reclamation]
tags: [hyper-v, storage, ssd, windows-server, linux, az-802, fisi]
modul: Windows Server Selbstlernmodul
status: lernen
erstellt: 2026-10-12
---

# TRIM und UNMAP

> [!info] Kontext
> Ergänzung zu [[VHD und VHDX]] · relevant für [[SSD vs HDD]], [[Storage Spaces]], [[Thin Provisioning]]
> Prüfungsrelevant: [[AZ-802 Übersicht]]

## 1. Problem
- Das Dateisystem löscht eine Datei → es markiert die Blöcke nur **intern** als frei.
- Der Datenträger (SSD, VHDX, SAN-LUN) **weiß davon nichts** und hält die Blöcke weiter für belegt.
- Folge: SSD wird langsamer (Garbage Collection), dynamische VHDX und Thin-LUNs geben keinen Platz frei.

## 2. Lösung
Das Betriebssystem meldet dem Datenträger: „Diese Blöcke sind frei.“

| Befehl | Schnittstelle | Typisch |
|---|---|---|
| **TRIM** | ATA/SATA | SATA-SSD |
| **UNMAP** | SCSI/SAS | SAN, Hyper-V-SCSI-Controller, VHDX |
| **DEALLOCATE** | NVMe | NVMe-SSD |

Gleiches Prinzip, drei Namen. Windows nennt es zusammenfassend **Delete Notification** bzw. **ReTrim**.

## 3. Ablauf in Hyper-V

```
Gast (EXA-DB01): Datei löschen
   ↓  UNMAP über virtuellen SCSI-Controller
VHDX: Blöcke als frei markieren → werden wiederverwendet
   ↓  TRIM/UNMAP an Host-Dateisystem
Host-SSD: Blöcke physisch freigegeben
```

> [!warning] Wichtig
> - Nur **VHDX** gibt UNMAP weiter, **VHD nicht** → siehe [[VHD und VHDX]].
> - Zuverlässig über **SCSI-Controller** (Gen-2-VMs haben nur SCSI → [[Generation 1 vs Generation 2 VM]]).
> - Bei **Fixed VHDX** bleibt die Dateigröße gleich, es profitiert nur die Host-SSD.
> - Bei **Dynamic VHDX** werden Blöcke intern frei. Die Datei schrumpft auf dem Host erst mit `Optimize-VHD`.

## 4. Windows

**Maschine: EXA-DB01** (oder jeder Windows-Gast/Host), PowerShell als Admin

```powershell
# Ist TRIM aktiv? 0 = aktiv, 1 = deaktiviert
fsutil behavior query DisableDeleteNotify

# TRIM aktivieren (falls 1)
fsutil behavior set DisableDeleteNotify 0

# Medientyp prüfen (SSD/HDD/Unspecified)
Get-PhysicalDisk | Select-Object FriendlyName, MediaType, BusType

# Manuelles ReTrim eines Volumes
Optimize-Volume -DriveLetter D -ReTrim -Verbose

# Automatischer Lauf: geplante Aufgabe (wöchentlich)
Get-ScheduledTask -TaskName 'ScheduledDefrag'
```

> [!note] Hinweis
> Erkennt Windows eine Disk als **SSD/Thin Provisioned**, führt `ScheduledDefrag` ReTrim aus, **kein** Defrag.

## 5. Linux

**Maschine: Linux-Gast (z. B. Ubuntu-VM)**

```bash
# Unterstützt die Disk discard? Werte > 0 bei DISC-GRAN/DISC-MAX = ja
lsblk --discard

# Einmalig alle Dateisysteme trimmen
sudo fstrim -av

# Periodisch (empfohlen statt mount-Option "discard")
sudo systemctl enable --now fstrim.timer
systemctl list-timers fstrim.timer
```

## 6. Hyper-V-Host

**Maschine: Hyper-V-Host (Home-Lab)**

```powershell
# Dynamische VHDX nach UNMAP physisch verkleinern (VM aus / Disk read-only)
Optimize-VHD -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx' -Mode Full

# Nur freie Blöcke an Host-Storage melden, ohne Kompaktierung
Optimize-VHD -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx' -Mode Retrim

# Vorher/Nachher vergleichen
Get-VHD -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx' |
  Select-Object VhdType, @{n='DateiGB';e={[math]::Round($_.FileSize/1GB,2)}}, @{n='MaxGB';e={$_.Size/1GB}}
```

| `-Mode` | Wirkung |
|---|---|
| `Full` | Kompaktieren + freie Blöcke entfernen (langsam, gründlich) |
| `Quick` | Nur bereits freie Blöcke freigeben |
| `Retrim` | Nur TRIM/UNMAP an Host senden, keine Kompaktierung |

## 7. Aufgaben

### Aufgabe 1 – Verständnis
Warum wird eine SSD ohne TRIM mit der Zeit langsamer?

> [!success]- Lösung
> SSD muss vor dem Schreiben ganze Blöcke löschen. Ohne TRIM hält sie gelöschte Daten für gültig und muss sie bei der Garbage Collection mitkopieren → Schreibverstärkung, weniger Leistung, mehr Verschleiß.

### Aufgabe 2 – Zuordnung
SATA-SSD, NVMe-SSD, VHDX am virtuellen SCSI-Controller: welcher Befehl jeweils?

> [!success]- Lösung
> TRIM · DEALLOCATE · UNMAP

### Aufgabe 3 – Szenario
In EXA-DB01 wurden 30 GB gelöscht. Die dynamische VHDX auf dem Host bleibt 45 GB groß. Ist das ein Fehler? Was tust du?

> [!success]- Lösung
> Kein Fehler. UNMAP markiert die Blöcke in der VHDX als frei, die Datei schrumpft nicht automatisch. VM herunterfahren → `Optimize-VHD -Mode Full` auf dem Host.

### Aufgabe 4 – Fehleranalyse
Eine alte VM nutzt eine `.vhd`. Trotz `Optimize-Volume -ReTrim` im Gast wird auf dem Host kein Platz frei. Ursache?

> [!success]- Lösung
> VHD unterstützt kein UNMAP. Lösung: VM aus → `Convert-VHD` nach VHDX → an SCSI anhängen.

### Aufgabe 5 – Praxis (Home-Lab)
1. Auf EXA-DB01 eine 10-GB-Testdatei auf D: erzeugen und löschen.
2. ReTrim ausführen.
3. Auf dem Host Dateigröße vorher/nachher `Optimize-VHD` vergleichen.

> [!success]- Lösung
> **EXA-DB01:**
> ```powershell
> fsutil file createnew D:\test.bin 10737418240
> Remove-Item D:\test.bin
> Optimize-Volume -DriveLetter D -ReTrim -Verbose
> Stop-Computer
> ```
> **Hyper-V-Host:** `Get-VHD` → `Optimize-VHD -Mode Full` → `Get-VHD`, `FileSize` vergleichen.
> Hinweis: `createnew` schreibt Nullen nur logisch, daher wächst die VHDX evtl. kaum. Für einen deutlichen Effekt echte Daten kopieren (z. B. ISO-Datei).

## 8. Validierung

**Maschine: EXA-DB01**
```powershell
[pscustomobject]@{
  TrimAktiv = (fsutil behavior query DisableDeleteNotify) -match 'NTFS DisableDeleteNotify = 0'
  Disk      = (Get-PhysicalDisk | Select-Object -First 1).MediaType
}
```

**Maschine: Hyper-V-Host (Home-Lab)**
```powershell
$vm = 'EXA-DB01'
Get-VMHardDiskDrive -VMName $vm | ForEach-Object {
  $v = Get-VHD -Path $_.Path
  [pscustomobject]@{
    Pfad       = $_.Path
    Controller = $_.ControllerType     # erwartet: SCSI
    Format     = $v.VhdFormat          # erwartet: VHDX
    Typ        = $v.VhdType
    DateiGB    = [math]::Round($v.FileSize/1GB,2)
  }
}
```

## 9. Merksätze
- TRIM/UNMAP/DEALLOCATE = „Block ist frei“-Meldung an den Datenträger.
- Hyper-V: nur VHDX + SCSI gibt sie weiter.
- Dynamic VHDX schrumpft erst mit `Optimize-VHD`.
- Windows: `DisableDeleteNotify = 0` · Linux: `fstrim.timer`.

## Verweise
- Intern: [[VHD und VHDX]] · [[Generation 1 vs Generation 2 VM]] · [[SSD vs HDD]] · [[Thin Provisioning]] · [[Storage Spaces]] · [[NTFS vs ReFS]] · [[Hyper-V Grundlagen]] · [[AZ-802 Übersicht]]
- Extern:
  - [Optimize-VHD (Microsoft Learn)](https://learn.microsoft.com/powershell/module/hyper-v/optimize-vhd)
  - [Optimize-Volume (Microsoft Learn)](https://learn.microsoft.com/powershell/module/storage/optimize-volume)
  - [fsutil behavior (Microsoft Learn)](https://learn.microsoft.com/windows-server/administration/windows-commands/fsutil-behavior)
