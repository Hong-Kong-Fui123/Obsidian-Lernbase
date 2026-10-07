---
title: Vorbereitung - Fehler einbauen
tags:
  - klausur
  - homelab
  - vorbereitung
---
# Vorbereitung - Fehler einbauen

Zurück zur Übersicht: [[00 Uebersicht Praxisklausuren|Übersicht Praxisklausuren]]

> [!warning] Nicht lesen, nur ausführen
> Die Skripte verraten die Fehler. Aufklappen, Befehle kopieren, auf der genannten Maschine ausführen, wieder zuklappen.
> Vorher einen Prüfpunkt (Checkpoint) aller VMs anlegen.

## Klausur 1 - Aufgabe 8

Erst ausführen, wenn Aufgabe 1 bis 7 fertig sind.

> [!danger]- Skript Klausur 1
> **Auf EXA-DHCP01** (PowerShell als Administrator):
>
> ```powershell
> Remove-DhcpServerInDC -DnsName EXA-DHCP01.exa.local -IPAddress 192.168.100.50
> Restart-Service DHCPServer
> ```
>
> **Auf EXA-CL01** (PowerShell als Administrator):
>
> ```powershell
> Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 8.8.8.8
> ipconfig /release
> Restart-Computer
> ```

## Klausur 3

Vor dem Start der Klausur ausführen, in dieser Reihenfolge.

> [!danger]- Skript Klausur 3
> **Auf EXA-CL01** (PowerShell als Administrator):
>
> ```powershell
> $a = New-ScheduledTaskAction -Execute "cmd.exe" `
>   -Argument '/c net use \\EXA-DC01\NETLOGON /user:EXA\aberg AltesKennwort1! & net use \\EXA-DC01\NETLOGON /delete /y'
> $t = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1)
> Register-ScheduledTask -TaskName "Laufwerk-Vertrieb" -Action $a -Trigger $t -User "SYSTEM" -RunLevel Highest
> ```
>
> **Auf EXA-DC01** (PowerShell als Domänen-Admin):
>
> ```powershell
> New-ADOrganizationalUnit -Name Labor -Path "[[OU]]=EXA,[[DC]]=exa,DC=local"
> Set-GPInheritance -Target "OU=Labor,OU=EXA,DC=exa,DC=local" -IsBlocked Yes
> Get-ADComputer EXA-CL01 | Move-ADObject -TargetPath "OU=Labor,OU=EXA,DC=exa,DC=local"
> Get-ADComputer EXA-CL01 | Set-ADAccountPassword -Reset `
>   -NewPassword (ConvertTo-SecureString "Kaputt-2026-xyz!" -AsPlainText -Force)
> ```
>
> Danach EXA-CL01 neu starten.
