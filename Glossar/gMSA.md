---
aliases: [Group Managed Service Account, Gruppenverwaltetes Dienstkonto, MSA]
tags: [glossar, glossar/windows-server, az-802]
en: "Group Managed Service Account"
de: "Gruppenverwaltetes Dienstkonto"
bereich: Windows-Server
---

# gMSA

Dienstkonto, dessen Kennwort das AD automatisch wechselt und das **mehrere** Server gleichzeitig nutzen dürfen.

- Voraussetzung: KDS-Stammschlüssel (`Add-KdsRootKey`), einmal pro Gesamtstruktur
- Berechtigte Server über `-PrincipalsAllowedToRetrieveManagedPassword`
- Server 2025 neu: **dMSA** (delegiertes MSA) zur Ablösung klassischer Dienstkonten

Maschine: **EXA-DC01 / Zielserver**
```powershell
New-ADServiceAccount -Name gmsa-web -DNSHostName gmsa-web.example.com -PrincipalsAllowedToRetrieveManagedPassword GG_Webserver
Test-ADServiceAccount gmsa-web
```

**Siehe auch:** [[AD]] · [[Kerberos]] · [[JEA]]
**Thema:** [[AZ-802 1 AD DS]] · [[AZ-802 Übersicht]]
