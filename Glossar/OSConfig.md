---
aliases: [Microsoft.OSConfig, OS-Konfiguration]
tags: [glossar, glossar/sicherheit-pki, az-802]
en: "OSConfig"
de: "Sicherheitskonfiguration (Server 2025)"
bereich: Sicherheit-PKI
---

# OSConfig

Werkzeug in Server 2025, das **Sicherheitsbaselines** anwendet und Abweichungen (Drift) automatisch korrigiert.

- PowerShell-Modul *Microsoft.OSConfig*
- Szenarien z. B. `SecurityBaseline/WS2025/MemberServer`, `…/DomainController`

Maschine: **EXA-SRV01**
```powershell
Install-Module Microsoft.OSConfig -Scope AllUsers -Force
Set-OSConfigDesiredConfiguration -Scenario SecurityBaseline/WS2025/MemberServer -Default
```

**Siehe auch:** [[App Control for Business]] · [[GPO]]
**Thema:** [[AZ-802 6 Sicherheit]] · [[AZ-802 Übersicht]]
