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

| Merkmal | VHD | VHDX |
|---|---|---|
| Max. Größe | 2040 GB (~2 TB) | 64 TB |
| Sektorgröße | 512 Byte | 512 Byte / 4 KB (logisch) |
| Schutz bei Stromausfall | nein | ja (internes **Log**) |
| Online-Resize | nein | ja (an SCSI-Controller) |
| [[TRIM-und-UNMAP\|TRIM/UNMAP]] | nein | ja |
| Boot in Gen-2-VM | nein | ja |
| Kompatibilität | Azure (Upload), Altsysteme | ab Server 2012 / Win 8 |
| Shared Disk (Gastcluster) | – | Shared VHDX → **VHD Set (.vhds)** ab 2016 |

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

## 8. Cmdlet-Referenz (Modul Hyper-V)

> [!info] Herkunft
> **Maschine: Hyper-V-Host (Home-Lab)**
> ```powershell
> Get-Command -Module Hyper-V -Noun VHD*
> Get-Help New-VHD -Examples      # Beispiele zu jedem Cmdlet
> Update-Help -Module Hyper-V     # Hilfe aktualisieren (einmalig, Internet nötig)
> ```

### Übersicht

| Cmdlet                  | Zweck                             | VM aus?            | Gilt für              |
| ----------------------- | --------------------------------- | ------------------ | --------------------- |
| [[#Test-VHD\|Test-VHD]] | Disk erstellen                    | –                  | VHD, VHDX, VHDS       |
| [#Get-VHD\|Get-`        | Eigenschaften anzeigen            | nein               | VHD, VHDX             |
| `Test-VHD`              | Integrität/Kette prüfen           | nein               | VHD, VHDX             |
| `Mount-VHD`             | Auf dem Host einhängen            | ja*                | VHD, VHDX, VHDS       |
| `Dismount-VHD`          | Vom Host trennen                  | –                  | VHD, VHDX, VHDS       |
| `Resize-VHD`            | Vergrößern/verkleinern            | VHDX an SCSI: nein | VHD, VHDX             |
| `Optimize-VHD`          | Dynamische Disk kompaktieren      | ja*                | Dynamic, Differencing |
| `Convert-VHD`           | Format/Typ ändern                 | ja                 | VHD ↔ VHDX            |
| `Merge-VHD`             | Differencing-Kette zusammenführen | ja                 | Differencing          |
| `Set-VHD`               | Parent-Pfad/Eigenschaften ändern  | ja                 | VHD, VHDX             |
| `Get-VHDSet`            | VHD Set anzeigen                  | nein               | VHDS                  |
| `Get-VHDSnapshot`       | Snapshots eines VHD Sets anzeigen | nein               | VHDS                  |
| `Remove-VHDSnapshot`    | Snapshot aus VHD Set entfernen    | –                  | VHDS                  |
| `Optimize-VHDSet`       | VHD-Set-Datei optimieren          | –                  | VHDS                  |

\* Disk darf nicht an eine laufende VM angehängt sein.

> [!note] VHD Set (.vhds)
> Gemeinsam genutzte Disk für **Gastcluster** (mehrere VMs greifen gleichzeitig zu), ab Server 2016, Nachfolger von Shared VHDX. Besteht aus `.vhds` (Metadaten) + `.avhdx` (Daten). Unterstützt Online-Resize und hostbasiertes Backup. → [[Failover-Cluster]]

---

### New-VHD
Erstellt eine neue virtuelle Disk. Die **Dateiendung** bestimmt das Format (`.vhd`, `.vhdx`, `.vhds`).

| Parameter | Bedeutung |
|---|---|
| `-Path` | Zielpfad inkl. Endung |
| `-SizeBytes` | Größe (`60GB`) |
| `-Fixed` / `-Dynamic` / `-Differencing` | Disk-Typ (Standard: Dynamic) |
| `-ParentPath` | Parent bei Differencing |
| `-BlockSizeBytes` | Blockgröße (VHDX Standard 32 MB) |
| `-LogicalSectorSizeBytes` | 512 oder 4096 |
| `-SourceDisk` | Physische Disk-Nummer als Quelle kopieren |

```powershell
New-VHD -Path 'D:\Hyper-V\Disks\EXA-WEB01-Data.vhdx' -SizeBytes 20GB -Dynamic
New-VHD -Path 'D:\Hyper-V\Disks\EXA-DC02.vhdx' -ParentPath 'D:\Hyper-V\Base\WS2025-Base.vhdx' -Differencing
New-VHD -Path 'D:\Hyper-V\Disks\Cluster-Quorum.vhds' -SizeBytes 1GB -Fixed
```

### Get-VHD
Zeigt Eigenschaften einer Disk.

| Eigenschaft | Bedeutung |
|---|---|
| `VhdFormat` | VHD / VHDX / VHDSet |
| `VhdType` | Fixed / Dynamic / Differencing |
| `Size` | Maximale Größe (aus Sicht der VM) |
| `FileSize` | Tatsächliche Dateigröße auf dem Host |
| `MinimumSize` | Kleinstmögliche Größe für `Resize-VHD` |
| `ParentPath` | Parent bei Differencing |
| `Attached` | Gerade eingehängt/angehängt? |
| `FragmentationPercentage` | Fragmentierung (Dynamic) |

```powershell
Get-VHD -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx' | Format-List *
Get-VM | Get-VMHardDiskDrive | Get-VHD | Select-Object Path, VhdType, @{n='DateiGB';e={[math]::Round($_.FileSize/1GB,1)}}
```

### Test-VHD
Prüft, ob Disk lesbar und Differencing-Kette intakt ist. Rückgabe `True`/`False`.

```powershell
Test-VHD -Path 'D:\Hyper-V\Disks\EXA-DC02.vhdx'
Get-ChildItem 'D:\Hyper-V\Disks\*.vhdx' | ForEach-Object { [pscustomobject]@{Datei=$_.Name; OK=Test-VHD -Path $_.FullName} }
```

### Mount-VHD
Hängt eine Disk auf dem **Host** ein (z. B. um Dateien offline zu bearbeiten).

| Parameter | Bedeutung |
|---|---|
| `-ReadOnly` | Nur lesend (nötig für `Optimize-VHD` im eingehängten Zustand) |
| `-NoDriveLetter` | Keinen Laufwerksbuchstaben vergeben |
| `-Passthru` | Gibt Disk-Objekt zurück (für Pipeline) |
| `-SnapshotId` | Bestimmten Snapshot eines VHD Sets einhängen |

```powershell
Mount-VHD -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx' -ReadOnly -Passthru | Get-Disk | Get-Partition
```

### Dismount-VHD
Trennt eine eingehängte Disk vom Host.

```powershell
Dismount-VHD -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx'
Dismount-VHD -DiskNumber 3
```

> [!warning] Immer trennen
> Eine auf dem Host eingehängte Disk blockiert den VM-Start („in use“).

### Resize-VHD
Ändert die maximale Größe.

| Parameter | Bedeutung |
|---|---|
| `-SizeBytes` | Neue Größe |
| `-ToMinimumSize` | Auf `MinimumSize` verkleinern |

```powershell
Resize-VHD -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx' -SizeBytes 80GB
```
Danach im Gast die Partition erweitern. **Maschine: EXA-DB01**
```powershell
$max = (Get-PartitionSupportedSize -DriveLetter D).SizeMax
Resize-Partition -DriveLetter D -Size $max
```

> [!warning] Verkleinern
> Nur VHDX. Erst im Gast die Partition verkleinern (`Resize-Partition`), sonst Datenverlust bzw. Fehler.

### Optimize-VHD
Kompaktiert dynamische und differenzierende Disks. Details: [[TRIM-und-UNMAP|TRIM und UNMAP]]

| `-Mode` | Wirkung |
|---|---|
| `Full` | Gründlich kompaktieren (langsam) |
| `Quick` | Nur bereits freie Blöcke freigeben |
| `Retrim` | TRIM/UNMAP an Host senden, nicht kompaktieren |
| `Pretrimmed` | Wie Quick, wenn vorher getrimmt wurde |
| `Prezeroed` | Wie Quick, wenn freie Bereiche vorher genullt wurden |

```powershell
Optimize-VHD -Path 'D:\Hyper-V\Disks\EXA-DB01-Data.vhdx' -Mode Full
```

### Convert-VHD
Erstellt eine **neue** Datei in anderem Format/Typ. Quelle bleibt erhalten.

| Parameter | Bedeutung |
|---|---|
| `-DestinationPath` | Zieldatei, Endung bestimmt Format |
| `-VHDType` | Fixed / Dynamic / Differencing |
| `-ParentPath` | Bei Ziel Differencing |
| `-DeleteSource` | Quelle nach Erfolg löschen |

```powershell
Convert-VHD -Path 'D:\Hyper-V\Disks\alt.vhd' -DestinationPath 'D:\Hyper-V\Disks\neu.vhdx' -VHDType Dynamic
Convert-VHD -Path 'D:\Hyper-V\Disks\EXA-WEB01.vhdx' -DestinationPath 'D:\Export\EXA-WEB01.vhd' -VHDType Fixed   # Azure-Upload
```

> [!warning] Nach Konvertierung
> VM zeigt noch auf die alte Datei → mit `Set-VMHardDiskDrive -Path` neue Datei eintragen.

### Merge-VHD
Führt Child in Parent zusammen.

| Parameter | Bedeutung |
|---|---|
| `-Path` | Child-Disk |
| `-DestinationPath` | Ziel-Vorfahr (Standard: direkter Parent) |

```powershell
Merge-VHD -Path 'D:\Hyper-V\Disks\EXA-DC02.vhdx' -DestinationPath 'D:\Hyper-V\Base\WS2025-Base.vhdx'
```

> [!danger] Golden Image
> Merge in eine Parent, die **weitere** Childs hat, macht diese unbrauchbar. Für Checkpoints `Remove-VMSnapshot` nutzen, nicht `Merge-VHD` → [[Checkpoints (Hyper-V)]]

### Set-VHD
Ändert Eigenschaften, v. a. Parent-Pfad reparieren.

| Parameter | Bedeutung |
|---|---|
| `-ParentPath` | Neuer Pfad der Parent (nach Verschieben) |
| `-PhysicalSectorSizeBytes` | 512 oder 4096 |
| `-ResetDiskIdentifier` | Neue Disk-ID (bei kopierten Disks, Kollision vermeiden) |

```powershell
Set-VHD -Path 'D:\Hyper-V\Disks\EXA-DC02.vhdx' -ParentPath 'E:\Base\WS2025-Base.vhdx'
```

### Get-VHDSet
Zeigt Infos zu einem VHD Set.

```powershell
Get-VHDSet -Path 'D:\Hyper-V\Disks\Cluster-Quorum.vhds' -GetAllPaths
```

### Get-VHDSnapshot
Listet Snapshots in einem VHD Set.

```powershell
Get-VHDSnapshot -Path 'D:\Hyper-V\Disks\Cluster-Quorum.vhds'
```

### Remove-VHDSnapshot
Entfernt einen Snapshot-Eintrag aus einem VHD Set.

```powershell
Get-VHDSnapshot -Path 'D:\Hyper-V\Disks\Cluster-Quorum.vhds' |
  Select-Object -First 1 | Remove-VHDSnapshot
```

### Optimize-VHDSet
Optimiert die `.vhds`-Metadatendatei eines VHD Sets.

```powershell
Optimize-VHDSet -Path 'D:\Hyper-V\Disks\Cluster-Quorum.vhds'
```

---

### Aufgaben Cmdlets

**Aufgabe C1** – Du hast die Parent `WS2025-Base.vhdx` von `D:` nach `E:\Base` verschoben. EXA-DC02 startet nicht. Welche zwei Cmdlets helfen?

> [!success]- Lösung
> `Test-VHD` (zeigt kaputte Kette) → `Set-VHD -ParentPath 'E:\Base\WS2025-Base.vhdx'`.

**Aufgabe C2** – `Get-VHD` zeigt `Size = 60GB`, `FileSize = 12GB`. Was bedeuten die Werte, welcher Disk-Typ?

> [!success]- Lösung
> `Size` = maximale Größe für die VM, `FileSize` = belegter Platz auf dem Host. Dynamic (oder Differencing).

**Aufgabe C3** – Eine Disk ist auf dem Host eingehängt und soll kompaktiert werden. Reihenfolge?

> [!success]- Lösung
> `Dismount-VHD` → `Mount-VHD -ReadOnly` → `Optimize-VHD -Mode Full` → `Dismount-VHD`. Alternativ direkt nach `Dismount-VHD` optimieren.

**Aufgabe C4** – Was ist der Unterschied zwischen `Convert-VHD` und `Merge-VHD`?

> [!success]- Lösung
> `Convert-VHD` erzeugt eine neue Datei mit anderem Format/Typ. `Merge-VHD` schreibt die Änderungen eines Childs in seinen Parent.

## Verweise
- Intern: [[Hyper-V Grundlagen]] · [[Generation 1 vs Generation 2 VM]] · [[Checkpoints (Hyper-V)]] · [[TRIM-und-UNMAP|TRIM und UNMAP]] · [[Sysprep und Golden Image]] · [[NTFS vs ReFS]] · [[Storage Spaces]] · [[Failover-Cluster]] · [[Azure Migrate]] · [[AZ-802 Übersicht]]
- Extern:
  - [New-VHD (Microsoft Learn)](https://learn.microsoft.com/powershell/module/hyper-v/new-vhd)
  - [Convert-VHD (Microsoft Learn)](https://learn.microsoft.com/powershell/module/hyper-v/convert-vhd)
  - [Optimize-VHD (Microsoft Learn)](https://learn.microsoft.com/powershell/module/hyper-v/optimize-vhd)
  - [Hyper-V Storage (Microsoft Learn)](https://learn.microsoft.com/windows-server/virtualization/hyper-v/)
