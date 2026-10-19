---
aliases: [Enhanced Session Mode, Erweiterte Sitzung]
tags: [glossar, glossar/virtualisierung, az-802]
en: "Enhanced Session Mode"
de: "Erweiterter Sitzungsmodus"
bereich: Virtualisierung
---

# Erweiterter Sitzungsmodus

VM-Konsole über RDP-Technik: Zwischenablage, lokale Laufwerke, Audio, Auflösung frei wählbar.

- Am Host aktivieren, Gast braucht Unterstützung (Windows; Linux mit xrdp)

Maschine: **Hyper-V-Host**
```powershell
Set-VMHost -EnableEnhancedSessionMode $true
```

**Siehe auch:** [[Hyper-V]] · [[RDP]]
**Thema:** [[AZ-802 3 Virtuelle Maschinen]] · [[AZ-802 Übersicht]]
