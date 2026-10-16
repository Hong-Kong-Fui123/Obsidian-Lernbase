---
aliases:
  - SMB Multichannel
  - SMB-Multichannel
  - Mehrkanal-SMB
tags:
  - glossar
  - glossar/netzwerk
en: SMB Multichannel
de: SMB-Mehrkanal
bereich: Netzwerk
---

**SMB Multichannel** = *SMB Multichannel*
**Deutsch:** SMB-Mehrkanal

## Kurz
SMB 3 nutzt automatisch **mehrere Netzwerkverbindungen gleichzeitig** zwischen zwei Rechnern – mehr Durchsatz und Ausfallsicherheit.

## Details
- Standardmäßig aktiv, braucht kein Teaming
- Wirkt bei der Livemigration-Option **SMB** mit

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
Get-SmbMultichannelConnection
```

## Prüfungsfrage
Was ist der Unterschied zu NIC-Teaming?

> [!success]- Lösung
> Multichannel arbeitet auf SMB-Ebene ohne Konfiguration; Teaming bündelt Karten auf Netzwerkebene.

## Siehe auch
[[SMB]] · [[SMB Direct]] · [[Hyper-V Livemigration]] · [[00_Glossar-Index]]
