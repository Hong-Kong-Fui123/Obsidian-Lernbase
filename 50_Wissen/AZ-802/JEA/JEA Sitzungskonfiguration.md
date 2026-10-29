---
typ: wissen
thema: AZ-802
tags: [az-802, jea, powershell, pssc]
aliases: [Sitzungskonfigurationsdatei JEA, pssc, Session Configuration, New-PSSessionConfigurationFile]
erstellt: 2026-10-29
status: lernen
---
# JEA 3 – Sitzungskonfiguration (.pssc)

Übersicht: [[JEA Übersicht]] · Zurück: [[JEA Rollenfunktionsdatei]] · Weiter: [[JEA RunAs-Konten]] · Glossar: [[Sitzungskonfiguration]]

> [!summary] Kernidee
> Die `.pssc` beschreibt den **Endpunkt**: **wer** sich verbinden darf, **welche Rolle** er bekommt, **unter welchem Konto** und **was protokolliert** wird.

## Wichtige Felder
| Feld | Bedeutung | Typischer Wert |
|---|---|---|
| `SessionType` | Grundumfang der Sitzung | **`RestrictedRemoteServer`** (immer für JEA) |
| `RoleDefinitions` | **Gruppe → Rolle(n)** | `@{ 'EXAMPLE\GG_DNS-Operatoren' = @{ RoleCapabilities = 'DnsOperator' } }` |
| `RunAsVirtualAccount` | temporäres lokales Admin-Konto | `$true` |
| `RunAsVirtualAccountGroups` | virtuelles Konto nur in **diesen** Gruppen statt Admin | `'DnsAdmins'` |
| `GroupManagedServiceAccount` | stattdessen gMSA (Netzwerkzugriff) | `'EXAMPLE\gmsa-jea'` |
| `TranscriptDirectory` | Ordner für Sitzungstranskripte | `C:\JEA\Transkripte` |
| `RequiredGroups` | zusätzliche Bedingung (z. B. Smartcard-/MFA-Gruppe) | `@{ And = 'GG_JEA-Benutzer', 'GG_Smartcard' }` |
| `MountUserDrive` + `UserDriveMaximumSize` | Laufwerk `User:` zum Kopieren von Dateien | `$true`, `50MB` |
| `LanguageMode` | Sprachumfang | bei RestrictedRemoteServer automatisch **NoLanguage** |

## Was steckt in `RestrictedRemoteServer`?
Nur wenige Grundbefehle (als sichere Proxy-Funktionen): `Get-Command`, `Get-Help`, `Get-FormatData`, `Select-Object`, `Measure-Object`, `Out-Default`, `Exit-PSSession`, `Clear-Host`. Alles Weitere kommt **nur aus den Rollen**.

## Rollen zuordnen
```powershell
RoleDefinitions = @{
  'EXAMPLE\GG_DNS-Operatoren' = @{ RoleCapabilities = 'DnsOperator' }
  'EXAMPLE\GG_Server-Admins'  = @{ RoleCapabilities = 'DnsOperator', 'DnsAdmin' }   # mehrere Rollen
  'EXAMPLE\hmeier'            = @{ RoleCapabilities = 'Auditor' }                   # einzelner Benutzer möglich
}
```
- Zuordnung immer an **Gruppen** (AGDLP-Gedanke → [[AD-Gruppen und AGDLP]]).
- Mehrere passende Einträge → Rollen werden **zusammengeführt**.

## Datei erstellen und prüfen
```powershell
# Maschine: EXA-SRV01
New-Item C:\JEA -ItemType Directory -Force
New-PSSessionConfigurationFile -Path C:\JEA\DnsOperator.pssc `
  -SessionType RestrictedRemoteServer `
  -RunAsVirtualAccount `
  -TranscriptDirectory 'C:\JEA\Transkripte' `
  -RoleDefinitions @{ 'EXAMPLE\GG_DNS-Operatoren' = @{ RoleCapabilities = 'DnsOperator' } }

Test-PSSessionConfigurationFile -Path C:\JEA\DnsOperator.pssc     # True = Syntax ok
```

## Prüfungsfrage
Welcher Sitzungstyp ist für JEA zu wählen, und was bewirkt er?

> [!success]- Lösung
> `RestrictedRemoteServer` – Sitzung im NoLanguage-Modus mit nur wenigen Grundbefehlen; alle weiteren Befehle kommen ausschließlich aus den zugeordneten Rollenfunktionen.

## Quellen
- [JEA Session Configurations – Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/jea/session-configurations)
