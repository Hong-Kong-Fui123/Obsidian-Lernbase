---
tags: [glossar, hyper-v]
aliases: [USN Rollback]
---
# USN-Rollback

**Kurz:** Ein DC mit veralteten USNs (z. B. aus alter Kopie) repliziert falsch → AD inkonsistent.

- Ursache: DC aus Export/Snapshot zurückgeholt oder parallel geklont
- Vermeiden: DC nur umziehen, System-State-Backup statt Export

**Siehe auch:** [[DC]] · [[VM-GenerationID]] · [[AD DS]] · [[HyperV-VM-Export-Import]]
