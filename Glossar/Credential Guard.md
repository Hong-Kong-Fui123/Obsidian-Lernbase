---
aliases:
  - Credential Guard
  - Windows Defender Credential Guard
  - Credential-Guard
tags:
  - glossar
  - glossar/sicherheit-pki
en: Credential Guard
de: Schutz von Anmeldeinformationen
bereich: Sicherheit-PKI
---

**Credential Guard** = *Credential Guard*
**Deutsch:** Schutz von Anmeldeinformationen

## Kurz
Isoliert Anmeldegeheimnisse (NTLM-Hashes, Kerberos-TGTs) per Virtualisierung (VBS) vom Betriebssystem – schützt gegen Pass-the-Hash.

## Details
- Ab Server 2025 auf domänenverbundenen Servern (außer DCs) **standardmäßig aktiv**
- Folge: [[CredSSP]] kann keine Anmeldedaten delegieren → CredSSP-Livemigration scheitert
- Lösung für Hyper-V: [[Kerberos]] mit [[Eingeschränkte Delegierung|eingeschränkter Delegierung]]

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard | Select-Object SecurityServicesRunning   # 1 = Credential Guard
```

## Prüfungsfrage
Warum funktioniert nach dem Upgrade auf Server 2025 die Livemigration nicht mehr?

> [!success]- Lösung
> Credential Guard ist standardmäßig an und blockiert CredSSP-Delegierung → auf Kerberos umstellen.

## Siehe auch
[[CredSSP]] · [[Kerberos]] · [[Hyper-V Livemigration]] · [[00_Glossar-Index]]
