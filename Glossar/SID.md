---
aliases:
  - SID
  - Security Identifier
tags:
  - glossar
  - glossar/virtualisierung
en: Security Identifier
de: Sicherheitskennung
bereich: Virtualisierung
---

**SID** = *Security Identifier*
**Deutsch:** Sicherheitskennung

## Kurz
Eindeutige Kennung für Computer, Benutzer und Gruppen in Windows und Active Directory.

## Details
- Rechte werden an SIDs vergeben, nicht an Namen
- Beim VM-Klon bleibt die Maschinen-SID gleich
- RID = letzter Teil der SID (500 = Administrator)

## Beispiel
Maschine: **EXA-DC01**
```powershell
Get-ADUser Administrator | Select SID
whoami /user
```

## Prüfungsfrage
Was passiert mit Berechtigungen, wenn ein Benutzer umbenannt wird?

> [!success]- Lösung
> Bleiben erhalten, weil sie an der SID hängen.

## Siehe auch
[[Sysprep]] · [[AD]] · [[HyperV-VM-Export-Import]] · [[00_Glossar-Index]]
