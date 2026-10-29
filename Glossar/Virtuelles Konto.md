---
aliases: [Virtual Account, RunAsVirtualAccount, NT SERVICE Konto]
tags: [glossar, glossar/sicherheit-pki, az-802, jea]
en: "Virtual Account"
de: "Virtuelles Konto"
bereich: Sicherheit-PKI
---

# Virtuelles Konto

Automatisch verwaltetes lokales Konto ohne Kennwort – bei JEA nur für die Dauer der Sitzung, standardmäßig **lokaler Admin**.

- Auf **DCs** Mitglied von **Domänen-Admins** → mit `RunAsVirtualAccountGroups` einschränken
- Keine Netzwerkidentität für Doppel-Hop → dafür [[gMSA]]
- Auch für Dienste: `NT SERVICE\<Dienstname>`
- Mehr: [[JEA RunAs-Konten]]

Maschine: **EXA-SRV01**
```powershell
New-PSSessionConfigurationFile -Path C:\JEA\X.pssc -SessionType RestrictedRemoteServer -RunAsVirtualAccount -RunAsVirtualAccountGroups 'DnsAdmins'
```

**Siehe auch:** [[gMSA]] · [[JEA]]
**Thema:** [[JEA Übersicht]] · [[AZ-802 2 Hybride Verwaltung]]
