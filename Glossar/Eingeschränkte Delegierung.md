---
aliases:
  - Eingeschränkte Delegierung
  - Constrained Delegation
  - KCD
  - Kerberos Constrained Delegation
  - Delegierung
tags:
  - glossar
  - glossar/sicherheit-pki
en: Kerberos Constrained Delegation
de: Eingeschränkte Delegierung
bereich: Sicherheit-PKI
---

**Eingeschränkte Delegierung** = *Kerberos Constrained Delegation*
**Deutsch:** Eingeschränkte Delegierung

## Kurz
Kerberos-Funktion: Ein Computerkonto darf im Namen eines Benutzers **nur bestimmte Dienste** auf einem anderen Server nutzen.

## Details
- Für Livemigration: am Konto jedes Hosts die Dienste **cifs** und **Microsoft Virtual System Migration Service** des anderen Hosts eintragen
- AD-Benutzer und -Computer → Computerkonto → Reiter **Delegierung** → „Beliebiges Authentifizierungsprotokoll“
- Einrichten nur als Domänen-Admin; wirkt nach AD-Replikation und neuem Ticket

## Beispiel
Maschine: **EXA-DC01**
```powershell
Set-ADComputer EXA-HV01 -Add @{'msDS-AllowedToDelegateTo' = @(
  'cifs/EXA-HV02.example.com',
  'Microsoft Virtual System Migration Service/EXA-HV02.example.com')}
```

## Prüfungsfrage
Welche zwei Dienste trägt man für Livemigration mit Speicher ein?

> [!success]- Lösung
> cifs (Dateien/Speicher) und Microsoft Virtual System Migration Service (VM).

## Siehe auch
[[Kerberos]] · [[CredSSP]] · [[AD]] · [[Hyper-V Livemigration]] · [[00_Glossar-Index]]
