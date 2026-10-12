---
aliases:
  - USN-Rollback
  - USN Rollback
tags:
  - glossar
  - glossar/virtualisierung
en: USN Rollback
de: USN-Rücksetzung
bereich: Virtualisierung
---

**USN-Rollback** = *USN Rollback*
**Deutsch:** USN-Rücksetzung

## Kurz
Ein DC mit veralteten Update Sequence Numbers (z. B. aus alter Kopie) repliziert fehlerhaft → AD wird inkonsistent.

## Details
- Ursache: DC aus Export/Snapshot zurückgeholt oder parallel geklont
- Folge: Änderungen werden nicht mehr repliziert, Ereignis 2095
- Vermeiden: DC nur umziehen, System-State-Backup nutzen

## Beispiel
Maschine: **EXA-DC01**
```powershell
repadmin /replsummary
repadmin /showrepl
```

## Prüfungsfrage
Warum ist ein alter DC-Export als Backup gefährlich?

> [!success]- Lösung
> Beim Zurückspielen hat der DC alte USNs → Replikationspartner ignorieren seine Änderungen.

## Siehe auch
[[DC]] · [[VM-GenerationID]] · [[AD DS]] · [[HyperV-VM-Export-Import]] · [[00_Glossar-Index]]
