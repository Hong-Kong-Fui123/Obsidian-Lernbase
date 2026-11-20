---
aliases: [VBS]
tags: [glossar, glossar/sicherheit, az-802]
en: Windows Defender Credential Guard
de: Credential Guard
bereich: sicherheit
---
# Credential Guard

**Definition:** Isoliert LSA-Geheimnisse per virtualisierungsbasierter Sicherheit gegen Pass-the-Hash.

**Prüfungsfalle:** Braucht UEFI, Secure Boot, Virtualisierung; schützt nicht vor Keyloggern.

**Prüfen:** `Get-CimInstance -Namespace root\Microsoft\Windows\DeviceGuard Win32_DeviceGuard`

↑ [[AZ-802 06 Sicherheit]] · [[00_Glossar-AZ-802-Index]]
