---
tags: [glossar, docker]
aliases: [Windows Container]
---
# Windows-Container

**Kurz:** Container mit Windows-Kernel; laufen nur auf Windows-Hosts.

- Basis-Images: Server Core, Nano Server (`mcr.microsoft.com/windows/...`)
- Image-Version muss zum Host passen (z. B. ltsc2025)
- Kein GUI, keine AD-Domänenmitgliedschaft (gMSA möglich)

**Siehe auch:** [[Prozess-Isolation]] · [[Hyper-V-Isolation]] · [[00_Docker-Uebersicht]]
