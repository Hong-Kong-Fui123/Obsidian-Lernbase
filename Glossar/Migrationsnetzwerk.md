---
aliases:
  - Migrationsnetzwerk
  - Livemigrationsnetzwerk
  - Migration Network
  - VMMigrationNetwork
tags:
  - glossar
  - glossar/virtualisierung
en: Live Migration Network
de: Migrationsnetzwerk
bereich: Virtualisierung
---

**Migrationsnetzwerk** = *Live Migration Network*
**Deutsch:** Migrationsnetzwerk

## Kurz
Netz(e), über die ein Host eingehende Livemigrationen annimmt.

## Details
- Empfehlung: eigenes, isoliertes Netz/VLAN – der Verkehr ist **unverschlüsselt**
- `-UseAnyNetworkForMigration $false` + `Add-VMMigrationNetwork`
- Im Cluster: Failovercluster-Manager → Netzwerke → Livemigrationseinstellungen
- Port TCP 6600 (bei SMB-Option TCP 445)

## Beispiel
Maschine: **EXA-HV01**
```powershell
Set-VMHost -UseAnyNetworkForMigration $false
Add-VMMigrationNetwork 192.168.10.0/24
Get-VMMigrationNetwork
```

## Prüfungsfrage
Warum sollte Livemigration ein eigenes Netz bekommen?

> [!success]- Lösung
> Unverschlüsselter RAM-Inhalt und hohe Last – isoliert ist es sicherer und stört den Clientverkehr nicht.

## Siehe auch
[[Livemigration]] · [[VLAN]] · [[SMB Direct]] · [[Hyper-V Livemigration]] · [[00_Glossar-Index]]
