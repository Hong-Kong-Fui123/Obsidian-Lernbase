---
typ: lab
thema: AZ-802
tags: [lab, az-802, jea, powershell, dns]
aliases: [Lab JEA, JEA Übung DNS]
datum: 2026-10-29
ort: Home-Lab
status: offen
ergebnis:
---
# JEA 7 – Lab: DNS-Operator ohne Admin-Rechte

Übersicht: [[JEA Übersicht]] · Zurück: [[JEA Sicherheit und Überwachung]] · Lab-Umgebung: [[VM-Infrastruktur]] · Fehler: [[Fehlerlog Home-Lab]]

## 🎯 Ziel
Benutzer **hmeier** (Gruppe *GG_DNS-Operatoren*, kein Admin) darf auf EXA-SRV01 nur: DNS-Zonen anzeigen, DNS-Cache leeren, DNS-Dienst neu starten.

## 🖥️ Aufbau
| Maschine | Rolle |
|---|---|
| EXA-DC01 | DC example.com, Benutzer + Gruppe anlegen |
| EXA-SRV01 | Zielserver mit DNS-Rolle und JEA-Endpunkt |
| EXA-CL01 | Client von hmeier |

## Schritt 1 – Benutzer und Gruppe
```powershell
# Maschine: EXA-DC01
New-ADGroup -Name GG_DNS-Operatoren -GroupScope Global -Path 'OU=Gruppen,DC=example,DC=com'
New-ADUser -Name hmeier -AccountPassword (Read-Host -AsSecureString 'Kennwort') -Enabled $true -Path 'OU=Benutzer,DC=example,DC=com'
Add-ADGroupMember GG_DNS-Operatoren -Members hmeier
```

## Schritt 2 – DNS-Rolle auf dem Zielserver
```powershell
# Maschine: EXA-SRV01
Install-WindowsFeature DNS -IncludeManagementTools
```

## Schritt 3 – Rollenfunktion (.psrc)
```powershell
# Maschine: EXA-SRV01
$m = 'C:\Program Files\WindowsPowerShell\Modules\JEA-DNS'
New-Item "$m\RoleCapabilities" -ItemType Directory -Force | Out-Null
New-Item "$m\JEA-DNS.psm1" -ItemType File -Force | Out-Null
New-ModuleManifest -Path "$m\JEA-DNS.psd1" -RootModule 'JEA-DNS.psm1'
New-PSRoleCapabilityFile -Path "$m\RoleCapabilities\DnsOperator.psrc" `
  -ModulesToImport 'DnsServer' `
  -VisibleCmdlets 'Get-DnsServerZone', 'Clear-DnsServerCache', `
     @{ Name = 'Restart-Service'; Parameters = @{ Name = 'Name'; ValidateSet = 'DNS' } }
```

## Schritt 4 – Sitzungskonfiguration (.pssc) registrieren
```powershell
# Maschine: EXA-SRV01
New-Item C:\JEA\Transkripte -ItemType Directory -Force | Out-Null
New-PSSessionConfigurationFile -Path C:\JEA\DnsOperator.pssc -SessionType RestrictedRemoteServer `
  -RunAsVirtualAccount -TranscriptDirectory C:\JEA\Transkripte `
  -RoleDefinitions @{ 'EXAMPLE\GG_DNS-Operatoren' = @{ RoleCapabilities = 'DnsOperator' } }
Test-PSSessionConfigurationFile C:\JEA\DnsOperator.pssc
Register-PSSessionConfiguration -Name DnsOperator -Path C:\JEA\DnsOperator.pssc -Force
Get-PSSessionCapability -ConfigurationName DnsOperator -Username EXAMPLE\hmeier
```

## Schritt 5 – Testen als hmeier
```powershell
# Maschine: EXA-CL01 (angemeldet als EXAMPLE\hmeier)
Enter-PSSession -ComputerName EXA-SRV01 -ConfigurationName DnsOperator
Get-Command                         # nur wenige Befehle
Get-DnsServerZone                   # ✅
Clear-DnsServerCache -Force         # ✅
Restart-Service -Name DNS           # ✅
Restart-Service -Name Spooler       # ❌ Wert nicht erlaubt
Stop-Service DNS                    # ❌ Befehl unbekannt
$a = 1                              # ❌ NoLanguage
Exit-PSSession
Enter-PSSession -ComputerName EXA-SRV01   # ❌ Standard-Endpunkt: Zugriff verweigert
```

## Schritt 6 – Protokoll prüfen
```powershell
# Maschine: EXA-SRV01
Get-ChildItem C:\JEA\Transkripte | Sort-Object LastWriteTime | Select-Object -Last 1 | Get-Content -TotalCount 30
```
Erwartet: Kopfzeilen mit **Benutzer EXAMPLE\hmeier** und **RunAs-Benutzer** (virtuelles Konto), danach alle Befehle.

## 🧯 Typische Fehler
| Symptom | Ursache | Lösung |
|---|---|---|
| Rolle wird nicht gefunden | `.psrc` nicht in `<Modul>\RoleCapabilities` | Ordnerstruktur prüfen, `$env:PSModulePath` |
| „Zugriff verweigert“ beim Verbinden | Benutzer nicht in Gruppe aus `RoleDefinitions` / Ticket alt | Gruppe prüfen, ab- und neu anmelden (`klist purge`) |
| Cmdlet fehlt trotz Freigabe | Modul nicht geladen | `ModulesToImport` ergänzen |
| Änderungen an `.pssc` wirken nicht | nicht neu registriert | `Unregister-…` + `Register-PSSessionConfiguration` |
| Netzwerkzugriff scheitert | virtuelles Konto ohne Netzwerkidentität | gMSA → [[JEA RunAs-Konten]] |

## 📝 Ergebnis
- [ ] Schritte 1–6 erledigt
- [ ] Beobachtung: Welche Befehle zeigte `Get-Command`?
