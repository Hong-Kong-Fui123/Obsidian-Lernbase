---
typ: wissen
thema: AZ-802
tags: [az-802, jea, gmsa, sicherheit]
aliases: [JEA virtuelles Konto, JEA gMSA, RunAs JEA]
erstellt: 2026-10-29
status: lernen
---
# JEA 4 – RunAs-Konten (virtuelles Konto oder gMSA)

Übersicht: [[JEA Übersicht]] · Zurück: [[JEA Sitzungskonfiguration]] · Weiter: [[JEA Bereitstellen und Verbinden]] · Glossar: [[Virtuelles Konto]] · [[gMSA]]

## Vergleich
| | **[[Virtuelles Konto]]** | **[[gMSA]]** | (keins) |
|---|---|---|---|
| Feld in `.pssc` | `RunAsVirtualAccount = $true` | `GroupManagedServiceAccount = 'EXAMPLE\gmsa-jea'` | – |
| Lebensdauer | nur während der Sitzung | dauerhaftes Domänenkonto | – |
| Rechte | **lokaler Admin** (Mitgliedsserver) | was du dem gMSA gibst | Rechte des Benutzers |
| Netzwerkzugriff (Doppel-Hop) | ❌ nein – nur lokaler Server | ✅ ja, als Computer-/Dienstkonto | Benutzerrechte |
| Nachvollziehbar | ✅ (Benutzer im Transkript) | ⚠ Netzwerkaktionen erscheinen als gMSA | ✅ |
| Einsatz | Standardfall | Zugriff auf Freigaben/andere Server nötig | wenn Benutzer selbst genug Rechte hat |
Virtuelles Konto und gMSA **nicht gleichzeitig**.

> [!warning] Falle auf Domänencontrollern
> Auf einem **DC** gibt es keine lokalen Admins – das virtuelle Konto wird dort Mitglied von **Domänen-Admins**!
> Lösung: `RunAsVirtualAccountGroups` mit genau den nötigen Gruppen (z. B. `DnsAdmins`) setzen oder gMSA mit gezielten Rechten nutzen.

## Beispiele
```powershell
# Virtuelles Konto, aber nur Mitglied von DnsAdmins (sinnvoll auf EXA-DC01)
New-PSSessionConfigurationFile -Path C:\JEA\DcDns.pssc -SessionType RestrictedRemoteServer `
  -RunAsVirtualAccount -RunAsVirtualAccountGroups 'DnsAdmins' `
  -RoleDefinitions @{ 'EXAMPLE\GG_DNS-Operatoren' = @{ RoleCapabilities = 'DnsOperator' } }
```
```powershell
# Maschine: EXA-DC01 – gMSA für JEA anlegen (KDS-Stammschlüssel vorhanden)
New-ADServiceAccount -Name gmsa-jea -DNSHostName gmsa-jea.example.com `
  -PrincipalsAllowedToRetrieveManagedPassword 'EXA-SRV01$'
# Maschine: EXA-SRV01
Install-ADServiceAccount gmsa-jea; Test-ADServiceAccount gmsa-jea
New-PSSessionConfigurationFile -Path C:\JEA\Fileshare.pssc -SessionType RestrictedRemoteServer `
  -GroupManagedServiceAccount 'EXAMPLE\gmsa-jea' `
  -RoleDefinitions @{ 'EXAMPLE\GG_Helpdesk' = @{ RoleCapabilities = 'FreigabeOperator' } }
```

## Prüfungsfrage
Ein JEA-Befehl soll auf eine Freigabe auf EXA-SRV02 zugreifen und scheitert mit „Zugriff verweigert“. Ursache und Lösung?

> [!success]- Lösung
> Das **virtuelle Konto** gilt nur lokal und hat keine Netzwerkidentität (Doppel-Hop). Lösung: **gMSA** als RunAs-Konto und dem gMSA die nötigen Rechte auf der Freigabe geben.

## Quellen
- [JEA Session Configurations – Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/jea/session-configurations)
- [JEA Security considerations – Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/jea/security-considerations?view=powershell-7.4)
