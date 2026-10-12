---
aliases:
  - VM-GenerationID
  - GenerationID
  - VM-Generation-ID
tags:
  - glossar
  - glossar/virtualisierung
en: VM-Generation ID
de: VM-Generationskennung
bereich: Virtualisierung
---

**VM-GenerationID** = *VM-Generation ID*
**Deutsch:** VM-Generationskennung

## Kurz
Von Hyper-V bereitgestellter Wert, der sich bei Wiederherstellung oder Klon einer VM ändert.

## Details
- Ein virtueller DC erkennt die Änderung und setzt seine InvocationID zurück
- Schützt **teilweise** vor [[USN-Rollback]]
- Seit Server 2012

## Prüfungsfrage
Macht die VM-GenerationID das Zurückspielen eines DC-Snapshots sicher?

> [!success]- Lösung
> Nur teilweise; empfohlen bleibt System-State-Backup und DC nie parallel klonen.

## Siehe auch
[[USN-Rollback]] · [[DC]] · [[HyperV-VM-Export-Import]] · [[00_Glossar-Index]]
