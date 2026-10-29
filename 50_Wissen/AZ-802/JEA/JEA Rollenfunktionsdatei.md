---
typ: wissen
thema: AZ-802
tags: [az-802, jea, powershell, psrc]
aliases: [Rollenfunktionsdatei JEA, psrc, Role Capability, New-PSRoleCapabilityFile]
erstellt: 2026-10-29
status: lernen
---
# JEA 2 – Rollenfunktionsdatei (.psrc)

Übersicht: [[JEA Übersicht]] · Zurück: [[JEA Grundlagen und Ablauf]] · Weiter: [[JEA Sitzungskonfiguration]] · Glossar: [[Rollenfunktionsdatei]]

> [!summary] Kernidee
> Die `.psrc` legt fest, **was** ein Benutzer in der JEA-Sitzung darf – Befehle, Parameter und sogar erlaubte **Werte**.

## Speicherort (häufigste Fehlerquelle!)
```
C:\Program Files\WindowsPowerShell\Modules\
└── JEA-DNS\                      ← Modulordner (Name frei wählbar)
    ├── JEA-DNS.psm1              ← kann leer sein
    ├── JEA-DNS.psd1              ← Modulmanifest (empfohlen)
    └── RoleCapabilities\         ← Name genau so!
        └── DnsOperator.psrc      ← Rollenname = Dateiname ohne .psrc
```
- Der Ordner muss unter einem Pfad aus `$env:PSModulePath` liegen.
- Gibt es zwei Rollen gleichen Namens in verschiedenen Modulen, ist das Ergebnis unklar → **eindeutige Namen**.

## Wichtige Felder
| Feld | Erlaubt | Beispiel |
|---|---|---|
| `VisibleCmdlets` | Cmdlets, optional mit Parametern und Werten | `'Restart-Service'` |
| `VisibleFunctions` | Funktionen (auch eigene aus `FunctionDefinitions`) | `'Get-DnsCacheInfo'` |
| `VisibleExternalCommands` | Programme (exe) mit **vollem Pfad** | `'C:\Windows\System32\ipconfig.exe'` |
| `VisibleProviders` | Provider wie FileSystem, Registry | `'FileSystem'` (nur wenn nötig) |
| `VisibleAliases` / `VisibleVariables` | Aliase / Variablen | – |
| `ModulesToImport` | Module, die geladen werden | `'DnsServer'` |
| `FunctionDefinitions` | eigene Funktionen direkt in der Datei | Hilfsfunktion mit Prüflogik |
| `ScriptsToProcess` | Skripte beim Sitzungsstart | selten |

## Befehle einschränken – 3 Stufen
```powershell
VisibleCmdlets = @(
  # 1) Cmdlet komplett erlaubt
  'Get-DnsServerZone',

  # 2) nur bestimmte Parameter
  @{ Name = 'Restart-Computer'; Parameters = @{ Name = 'Force' } },

  # 3) Parameter mit erlaubten Werten (ValidateSet) oder Muster (ValidatePattern)
  @{ Name = 'Restart-Service'; Parameters = @{ Name = 'Name'; ValidateSet = 'DNS', 'Spooler' } },
  @{ Name = 'Get-Service';     Parameters = @{ Name = 'Name'; ValidatePattern = '^DNS.*' } }
)
```
- Platzhalter möglich: `'Get-DnsServer*'` – Vorsicht, erlaubt auch künftig neue Cmdlets.

## Datei erstellen
```powershell
# Maschine: EXA-SRV01
$m = 'C:\Program Files\WindowsPowerShell\Modules\JEA-DNS'
New-Item -Path "$m\RoleCapabilities" -ItemType Directory -Force
New-Item -Path "$m\JEA-DNS.psm1" -ItemType File -Force
New-ModuleManifest -Path "$m\JEA-DNS.psd1" -RootModule 'JEA-DNS.psm1'

New-PSRoleCapabilityFile -Path "$m\RoleCapabilities\DnsOperator.psrc" `
  -ModulesToImport 'DnsServer' `
  -VisibleCmdlets 'Get-DnsServerZone', 'Clear-DnsServerCache', `
     @{ Name = 'Restart-Service'; Parameters = @{ Name = 'Name'; ValidateSet = 'DNS' } } `
  -VisibleExternalCommands 'C:\Windows\System32\ipconfig.exe'
```

## Eigene Funktion statt gefährlichem Cmdlet
```powershell
FunctionDefinitions = @{
  Name = 'Get-DnsDienstStatus'
  ScriptBlock = { Get-Service -Name DNS | Select-Object Name, Status }
}
VisibleFunctions = 'Get-DnsDienstStatus'
```
→ Benutzer sieht nur die sichere Funktion, nicht `Get-Service` mit allen Möglichkeiten. Funktionen laufen intern mit voller Sprache – deshalb **Eingaben prüfen**.

## Mehrere Rollen
- Bekommt ein Benutzer mehrere Rollen, werden die Rechte **zusammengeführt** (Vereinigung).
- Ist ein Cmdlet in einer Rolle eingeschränkt und in einer anderen frei, gilt das **Freiere**.

## Prüfungsfrage
Warum findet JEA die Datei `C:\JEA\DnsOperator.psrc` nicht?

> [!success]- Lösung
> Rollenfunktionsdateien müssen in einem Unterordner **`RoleCapabilities`** eines **Moduls** liegen, dessen Pfad in `$env:PSModulePath` steht – nicht in einem beliebigen Ordner.

## Quellen
- [JEA Role Capabilities – Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/jea/role-capabilities)
