---
typ: wissen
thema: AZ-802
tags: [az-802, jea, powershell, bereitstellung]
aliases: [JEA registrieren, Register-PSSessionConfiguration, JEA verbinden]
erstellt: 2026-10-29
status: lernen
---
# JEA 5 – Bereitstellen und Verbinden

Übersicht: [[JEA Übersicht]] · Zurück: [[JEA RunAs-Konten]] · Weiter: [[JEA Sicherheit und Überwachung]]

## Endpunkt registrieren und verwalten
| Aufgabe | Befehl (Maschine: Zielserver, z. B. EXA-SRV01) |
|---|---|
| Datei prüfen | `Test-PSSessionConfigurationFile -Path C:\JEA\DnsOperator.pssc` |
| Registrieren | `Register-PSSessionConfiguration -Name DnsOperator -Path C:\JEA\DnsOperator.pssc` |
| Anzeigen | `Get-PSSessionConfiguration -Name DnsOperator` |
| Ändern (neue .pssc) | `Unregister-PSSessionConfiguration -Name DnsOperator`, dann neu `Register-…` |
| Entfernen | `Unregister-PSSessionConfiguration -Name DnsOperator` |
| Was darf Benutzer X? | `Get-PSSessionCapability -ConfigurationName DnsOperator -Username EXAMPLE\hmeier` |
- Registrieren startet **WinRM neu** → bestehende Remoting-Sitzungen brechen ab.
- Änderungen an der **`.psrc`** wirken bei der **nächsten Sitzung** ohne Neuregistrierung; Änderungen an der **`.pssc`** brauchen Neuregistrierung.

## Verbinden (Maschine: Admin-PC / Helpdesk-PC)
```powershell
# interaktiv
Enter-PSSession -ComputerName EXA-SRV01 -ConfigurationName DnsOperator
Get-Command                     # nur erlaubte Befehle
Clear-DnsServerCache -Force
Exit-PSSession

# einzelner Befehl
Invoke-Command -ComputerName EXA-SRV01 -ConfigurationName DnsOperator -ScriptBlock { Get-DnsServerZone }

# implizites Remoting: JEA-Befehle lokal wie eigene nutzen
$s = New-PSSession -ComputerName EXA-SRV01 -ConfigurationName DnsOperator
Import-PSSession -Session $s -Prefix JEA -AllowClobber
Get-JEADnsServerZone
```
> [!info] `Invoke-Command` mit Skriptblock
> Im NoLanguage-Modus darf der Skriptblock nur **erlaubte Befehle** mit festen Werten enthalten – keine Variablen oder Schleifen.

## Auf viele Server verteilen
| Weg | Kernpunkt |
|---|---|
| Skript / `Invoke-Command` | `.psrc`-Modul kopieren + `.pssc` registrieren auf jedem Server |
| **DSC** | Ressource *JeaEndpoint* (Modul *JustEnoughAdministration*) – Konfiguration wird erzwungen |
| Gruppenrichtlinie | Dateien verteilen + Startskript zum Registrieren |
| **Windows Admin Center** | eigene RBAC-Rollen basieren auf JEA (*Administratoren*, *Hyper-V-Administratoren*, *Leser*) |
```powershell
# Maschine: EXA-DC01 – Modul + Konfiguration auf mehrere Server kopieren und registrieren
$server = 'EXA-SRV01','EXA-SRV02'
foreach ($s in $server) {
  $ziel = New-PSSession -ComputerName $s
  Copy-Item 'C:\JEA-Paket\JEA-DNS' -Destination 'C:\Program Files\WindowsPowerShell\Modules\' -Recurse -ToSession $ziel -Force
  Copy-Item 'C:\JEA-Paket\DnsOperator.pssc' -Destination 'C:\JEA\' -ToSession $ziel -Force
  Invoke-Command -Session $ziel { Register-PSSessionConfiguration -Name DnsOperator -Path C:\JEA\DnsOperator.pssc -Force }
}
```

## Prüfungsfrage
Du hast in der `.psrc` ein Cmdlet ergänzt. Musst du den Endpunkt neu registrieren?

> [!success]- Lösung
> Nein – Rollenfunktionen werden bei jeder neuen Sitzung gelesen. Neu registrieren nur bei Änderungen an der `.pssc`.

## Quellen
- [JEA Registering configurations – Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/jea/register-jea)
- [Using JEA – Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/jea/using-jea)
