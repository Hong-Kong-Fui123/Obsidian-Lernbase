---
aliases:
  - CredSSP
  - Credential Security Support Provider
tags:
  - glossar
  - glossar/sicherheit-pki
en: Credential Security Support Provider
de: Anmeldeinformationen-Sicherheitsanbieter
bereich: Sicherheit-PKI
---

**CredSSP** = *Credential Security Support Provider*
**Deutsch:** Anmeldeinformationen-Sicherheitsanbieter

## Kurz
Authentifizierungsprotokoll, das die Anmeldedaten des Benutzers an einen Remoteserver weitergibt. Früher Standard für Livemigration.

## Details
- Keine AD-Konfiguration nötig, aber man muss **am Quellhost angemeldet** sein
- Typischer Fehler: `0x8009030E No credentials are available in the security package`
- **Server 2025:** [[Credential Guard]] ist standardmäßig an → CredSSP-Livemigration funktioniert nicht mehr
- Auch genutzt bei RDP (NLA) und PowerShell-Remoting mit Doppel-Hop

## Beispiel
Maschine: **EXA-HV01**
```powershell
Set-VMHost -VirtualMachineMigrationAuthenticationType CredSSP   # nur bis Server 2022 sinnvoll
```

## Prüfungsfrage
Warum scheitert eine CredSSP-Livemigration, die von einem Verwaltungs-PC gestartet wird?

> [!success]- Lösung
> CredSSP verlangt eine Anmeldung am Quellhost; der Verwaltungs-PC kann die Anmeldedaten nicht weiterreichen (Doppel-Hop).

## Siehe auch
[[Kerberos]] · [[Eingeschränkte Delegierung]] · [[Credential Guard]] · [[Hyper-V Livemigration]] · [[00_Glossar-Index]]
