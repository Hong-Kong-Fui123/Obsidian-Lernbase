---
title: Hyper-V – VM Export & Import
aliases: [VM Export, VM Import, Export-VM, Import-VM, VM umziehen]
tags: [hyper-v, windows-server, powershell, homelab, aufgabe, klausur]
modul: Windows Server Selbstlernmodul
erstellt: 2026-10-12
status: aktiv
---

# Hyper-V – VM Export & Import

> [!info] Lernziel
> VM zwischen zwei Hyper-V-Hosts sicher umziehen/klonen: exportieren, übertragen, Kompatibilität prüfen, importieren, validieren.

## Inhalt
1. [[#1 Grundlagen]]
2. [[#2 Aufbau eines Exports]]
3. [[#3 Import-Modi]]
4. [[#4 Voraussetzungen & Stolperfallen]]
5. [[#5 Export durchführen]]
6. [[#6 Übertragen]]
7. [[#7 Import durchführen]]
8. [[#8 Validierung (PowerShell)]]
9. [[#9 Lab-Szenario EXA-SRV02 Desktop → Laptop]]
10. [[#10 Aufgaben]]
11. [[#11 Klausur]]
12. [[#12 Glossar]]
13. [[#13 Verweise]]

---

## 1 Grundlagen

| Begriff | Kurz |
|---|---|
| [[#^export\|Export]] | Kopiert Konfiguration + [[#^vhdx\|VHDX]] + [[#^checkpoint\|Checkpoints]] in einen Ordner |
| [[#^import\|Import]] | Registriert/kopiert diesen Ordner als VM auf einem Host |
| Live-Export | Export bei laufender VM möglich (seit 2012 R2) – sauberer: VM vorher herunterfahren |

- Export ≠ Backup-Strategie (kein Versionsmanagement, keine Zeitplanung).
- Export ≠ Live-Migration (Live-Migration verschiebt ohne Downtime, braucht Cluster/Shared-Nothing-Konfiguration).
- Alternative ohne Export: VHDX kopieren + neue VM anlegen → Konfiguration geht verloren.

---

## 2 Aufbau eines Exports

```text
E:\Export\EXA-SRV02\
├── Virtual Machines\
│   ├── <GUID>.vmcx      ← Konfiguration
│   ├── <GUID>.vmrs      ← Laufzeitstatus (RAM/Saved State)
│   └── <GUID>.vmgs      ← Gastzustand (u. a. vTPM, nur Gen2)
├── Virtual Hard Disks\
│   └── EXA-SRV02.vhdx
└── Snapshots\           ← Checkpoints (.vmcx/.avhdx)
```

Dateitypen: [[#^vmcx|VMCX]] · [[#^vmrs|VMRS]] · [[#^vmgs|VMGS]] · [[#^vhdx|VHDX]] · [[#^avhdx|AVHDX]]

---

## 3 Import-Modi

| Modus (GUI, engl.) | PowerShell | VM-ID | Dateien | Einsatz |
|---|---|---|---|---|
| Register the virtual machine in-place | `Import-VM -Path` | bleibt | bleiben am Ort | Dateien liegen schon final |
| Restore the virtual machine | `Import-VM -Path -Copy` | bleibt | werden kopiert | **Umzug** (Original wird gelöscht) |
| Copy the virtual machine | `Import-VM -Path -Copy -GenerateNewId` | **neu** | werden kopiert | **Klon** (Original läuft weiter) |

> [!warning] Neue VM-ID ≠ neue Identität im Netz
> `-GenerateNewId` ändert nur die Hyper-V-ID. Computername, [[#^sid|SID]], IP und Domänenkonto bleiben gleich → Klon nie parallel zum Original im selben Netz starten ohne [[#^sysprep|Sysprep]] bzw. Umbenennen/Neu-Joinen.

---

## 4 Voraussetzungen & Stolperfallen

| Prüfpunkt | Problem | Lösung |
|---|---|---|
| [[#^konfigversion\|Konfigurationsversion]] | VM neuer als Zielhost → kein Import | `Get-VMHostSupportedVersion` auf Zielhost |
| [[#^vswitch\|vSwitch]]-Name | Switch fehlt → Inkompatibilität 33012 | gleichen Namen anlegen oder per [[#^compare\|Compare-VM]] umhängen |
| Saved State | andere CPU → Start schlägt fehl | vor Export herunterfahren oder `Remove-VMSavedState` |
| [[#^vtpm\|vTPM]] (Gen2) | Guardian-Zertifikate fehlen → VM startet nicht | Zertifikate „Shielded VM Local Certificates“ mitnehmen |
| Domain Controller | Klon/alte Kopie → [[#^usn\|USN-Rollback]] | DC nur **umziehen**, nie parallel betreiben; [[#^genid\|VM-GenerationID]] schützt nur teilweise |
| Speicherplatz | Export = volle VHDX-Größe (dynamisch: belegte Größe) | `Get-VHD` → `FileSize` prüfen |
| Pfade | Import legt VHDX sonst im Standardpfad ab | `-VirtualMachinePath`, `-VhdDestinationPath` setzen |

---

## 5 Export durchführen

**GUI** (Quellhost): Hyper-V Manager → VM → *Export…* → Zielordner.

**PowerShell** (Quellhost, Admin):
```powershell
# Maschine: Quell-Hyper-V-Host
Stop-VM -Name EXA-SRV02                       # sauber herunterfahren
Get-VM EXA-SRV02 | Select Name, State, Version, Generation
Export-VM -Name EXA-SRV02 -Path 'E:\Export'

# Nur einen Checkpoint als eigenständige VM exportieren
Get-VMSnapshot -VMName EXA-SRV02
Export-VMSnapshot -VMName EXA-SRV02 -Name 'Basis' -Path 'E:\Export\Snap'
```

> [!tip] Checkpoint-Export
> `Export-VMSnapshot` erzeugt eine VM **ohne** Checkpoint-Kette (zusammengeführt) → ideal als „Golden Image“-Startzustand.

---

## 6 Übertragen

```powershell
# Maschine: Quell-Hyper-V-Host  (Ziel-Freigabe \\ZIELHOST\Import muss existieren)
robocopy 'E:\Export\EXA-SRV02' '\\ZIELHOST\Import\EXA-SRV02' /E /J /MT:8 /R:2 /W:5 /LOG:E:\Export\robocopy.log
```

| Schalter | Wirkung |
|---|---|
| `/E` | alle Unterordner inkl. leerer |
| `/J` | ungepufferte E/A → schneller bei großen Dateien (VHDX) |
| `/MT:8` | 8 Threads |
| `/R:2 /W:5` | 2 Wiederholungen, 5 s Wartezeit |

Alternativ: externe SSD.

---

## 7 Import durchführen

**GUI** (Zielhost): Hyper-V Manager → *Import Virtual Machine…* → Ordner → VM wählen → Import-Typ ([[#3 Import-Modi]]) → Pfade → ggf. Switch zuweisen.

**PowerShell mit Kompatibilitätsbericht** (Zielhost, Admin):
```powershell
# Maschine: Ziel-Hyper-V-Host
Get-VMHostSupportedVersion | Select Version, IsDefault
Get-VMSwitch | Select Name, SwitchType

$vmcx = (Get-ChildItem 'D:\Import\EXA-SRV02\Virtual Machines\*.vmcx').FullName

$report = Compare-VM -Path $vmcx -Copy `
          -VirtualMachinePath 'D:\Hyper-V\EXA-SRV02' `
          -VhdDestinationPath 'D:\Hyper-V\EXA-SRV02\Virtual Hard Disks'

$report.Incompatibilities | Format-Table MessageId, Message -AutoSize

# Beispiel 33012: Switch nicht gefunden → auf vorhandenen Switch umhängen
$report.Incompatibilities |
    Where-Object MessageId -eq 33012 |
    ForEach-Object { $_.Source | Connect-VMNetworkAdapter -SwitchName 'LabSwitch' }

Import-VM -CompatibilityReport $report
```

> [!note] Klon statt Umzug
> `-GenerateNewId` zusätzlich bei `Compare-VM` setzen. Danach im Gast: Sysprep oder Umbenennen + Neu-Joinen.

---

## 8 Validierung (PowerShell)

```powershell
# Maschine: Ziel-Hyper-V-Host
$vm = Get-VM -Name EXA-SRV02
$vm | Select Name, State, Version, Generation, VMId, Path
Get-VMHardDiskDrive -VMName EXA-SRV02 | Select Path
Get-VMNetworkAdapter -VMName EXA-SRV02 | Select SwitchName, MacAddress, IPAddresses
Get-VMSnapshot -VMName EXA-SRV02

# Ampel-Check
$checks = [ordered]@{
  'VM vorhanden'      = [bool]$vm
  'VHDX existiert'    = (Get-VMHardDiskDrive -VMName EXA-SRV02 | ForEach-Object { Test-Path $_.Path }) -notcontains $false
  'Switch verbunden'  = -not [string]::IsNullOrEmpty((Get-VMNetworkAdapter -VMName EXA-SRV02).SwitchName)
}
$checks.GetEnumerator() | ForEach-Object { '{0,-18} {1}' -f $_.Key, $(if ($_.Value) {'OK'} else {'FEHLER'}) }

Start-VM -Name EXA-SRV02
```

```powershell
# Maschine: EXA-SRV02 (nach Start, im Gast)
Test-ComputerSecureChannel -Verbose      # Domänenvertrauen ok?
Test-Connection EXA-DC01 -Count 2
```

---

## 9 Lab-Szenario EXA-SRV02 Desktop → Laptop

Ausgangslage: Lab soll auf den Laptop (Dell G15, Server 2025 + Hyper-V), um in der Schule ohne Desktop zu arbeiten.

| Schritt | Maschine | Aktion |
|---|---|---|
| 1 | Laptop-Host | `Get-VMHostSupportedVersion`, vSwitch-Name prüfen/anlegen |
| 2 | Desktop-Host | EXA-SRV02 herunterfahren, `Export-VM` |
| 3 | Desktop-Host | `robocopy` / externe SSD |
| 4 | Laptop-Host | `Compare-VM` → Inkompatibilitäten beheben → `Import-VM` (**Restore**, ohne neue ID) |
| 5 | Laptop-Host | [[#8 Validierung (PowerShell)]] |
| 6 | Desktop-Host | Original erst löschen, wenn Laptop-VM getestet ist |

> [!danger] DC mitnehmen?
> EXA-SRV02 braucht EXA-DC01 für die Anmeldung. EXA-DC01 nur **umziehen** (Original danach nie wieder starten) – sonst [[#^usn|USN-Rollback]].

---

## 10 Aufgaben

### Aufgabe 1 – Import-Modus wählen
Du willst eine Test-VM duplizieren, Original läuft weiter. Welchen Modus nimmst du und warum reicht das allein nicht?

> [!hint]- Hinweis
> Was ändert `-GenerateNewId` – und was **nicht**?

> [!success]- Lösung
> *Copy* (`-Copy -GenerateNewId`). Nur Hyper-V-ID neu; Computername/SID/IP gleich → Sysprep oder umbenennen + IP ändern + neu joinen. → [[#3 Import-Modi]]

### Aufgabe 2 – Inkompatibilität beheben
Import meldet `MessageId 33012`. Ursache? Befehl zur Behebung?

> [!hint]- Hinweis
> Welche Ressource des Quellhosts existiert auf dem Zielhost evtl. nicht unter gleichem Namen?

> [!success]- Lösung
> vSwitch nicht gefunden. `$_.Source | Connect-VMNetworkAdapter -SwitchName 'LabSwitch'` im Kompatibilitätsbericht, dann `Import-VM -CompatibilityReport $report`. → [[#7 Import durchführen]]

### Aufgabe 3 – Praxis (Home-Lab)
Exportiere EXA-CL01, importiere sie als Klon auf **demselben** Host unter neuem Pfad. Prüfe per PowerShell, dass zwei unterschiedliche `VMId` existieren.

> [!success]- Lösung
> ```powershell
> # Maschine: Hyper-V-Host (Desktop)
> Export-VM -Name EXA-CL01 -Path 'E:\Export'
> $vmcx = (Get-ChildItem 'E:\Export\EXA-CL01\Virtual Machines\*.vmcx').FullName
> $vm = Import-VM -Path $vmcx -Copy -GenerateNewId `
>       -VirtualMachinePath 'E:\Hyper-V\EXA-CL01-Klon' `
>       -VhdDestinationPath 'E:\Hyper-V\EXA-CL01-Klon\VHD'
> Rename-VM -VM $vm -NewName 'EXA-CL01-Klon'
> Get-VM EXA-CL01* | Select Name, VMId      # zwei verschiedene IDs
> ```
> Klon nicht starten, solange Original im Netz läuft (gleicher Name/SID).

### Aufgabe 4 – Denkfrage
Warum ist ein alter Export eines DCs als „Backup“ gefährlich?

> [!success]- Lösung
> Wiederhergestellter DC hat veraltete USNs → Replikationspartner ignorieren Änderungen → [[#^usn|USN-Rollback]], inkonsistentes AD. Richtig: System-State-Backup (Windows Server Backup) bzw. autoritative/nicht-autoritative Wiederherstellung.

---

## 11 Klausur

**Zeit: 20 Min · 20 Punkte**

1. Nenne die drei Import-Modi und je einen Einsatzzweck. *(6 P)*
2. Welche Dateien enthält der Ordner `Virtual Machines` eines Exports? Funktion je Datei. *(3 P)*
3. Schreibe den Befehl, der VM `EXA-WEB01` nach `F:\Export` exportiert. Maschine angeben. *(2 P)*
4. Warum sollte vor einem Export ein Saved State entfernt werden? *(2 P)*
5. Ablauf eines Imports mit Kompatibilitätsprüfung in PowerShell (Cmdlets in Reihenfolge). *(4 P)*
6. Unterschied Export/Import vs. Live-Migration. *(3 P)*

> [!success]- Lösungen
> 1. Register in-place (Dateien liegen final) · Restore (Umzug, gleiche ID) · Copy (Klon, neue ID) – [[#3 Import-Modi]]
> 2. `.vmcx` Konfiguration · `.vmrs` Laufzeitstatus · `.vmgs` Gastzustand/vTPM – [[#2 Aufbau eines Exports]]
> 3. Quell-Hyper-V-Host: `Export-VM -Name EXA-WEB01 -Path 'F:\Export'`
> 4. Saved State ist CPU-abhängig → Start auf anderem Host kann scheitern.
> 5. `Get-VMHostSupportedVersion` → `Compare-VM` → `$report.Incompatibilities` beheben → `Import-VM -CompatibilityReport`
> 6. Export/Import: Offline-Kopie, Downtime, kein Cluster nötig. Live-Migration: ohne Downtime, Hosts direkt verbunden, Konfiguration (Delegierung/Auth) nötig.

---

## 12 Glossar

| Begriff | Erklärung |
|---|---|
| **Export** | Kopie einer VM (Konfig, Disks, Checkpoints) in einen portablen Ordner. ^export |
| **Import** | Registrierung bzw. Kopie eines Exports als VM auf einem Host. ^import |
| **VMCX** | Binäre VM-Konfigurationsdatei (ab Server 2016, ersetzt XML). ^vmcx |
| **VMRS** | Laufzeitstatus-Datei (RAM-Inhalt, Saved State). ^vmrs |
| **VMGS** | Gastzustandsdatei, u. a. vTPM-Daten (Gen2). ^vmgs |
| **VHDX** | Virtuelle Festplatte, max. 64 TB, ausfallsicherer als VHD. ^vhdx |
| **AVHDX** | Differenzdatenträger eines Checkpoints. ^avhdx |
| **Checkpoint** | Zeitpunkt-Zustand einer VM (früher Snapshot); Standard vs. Produktion. ^checkpoint |
| **Konfigurationsversion** | Version des VM-Formats; Zielhost muss sie unterstützen. ^konfigversion |
| **vSwitch** | Virtueller Switch (External/Internal/Private) im Hyper-V. ^vswitch |
| **Compare-VM** | Erstellt Kompatibilitätsbericht vor dem Import. ^compare |
| **vTPM** | Virtuelles TPM für Gen2-VMs (BitLocker, Secure Boot). ^vtpm |
| **VM-GenerationID** | Von Hyper-V gesetzter Zähler; DC erkennt Wiederherstellung und schützt teilweise vor USN-Rollback. ^genid |
| **USN-Rollback** | Veralteter DC repliziert mit alten USNs → AD inkonsistent. ^usn |
| **SID** | Security Identifier, eindeutige Kennung von Computer/Benutzer. ^sid |
| **Sysprep** | Generalisiert Windows (neue SID, OOBE) für Klone. ^sysprep |

---

## 13 Verweise
- [[Glossar]]
- [[HyperV-Grundlagen]] · [[Hyper-V Checkpoints]] · [[Active Directory – Replikation]]
- Microsoft Learn: Export and Import virtual machines (Hyper-V)
