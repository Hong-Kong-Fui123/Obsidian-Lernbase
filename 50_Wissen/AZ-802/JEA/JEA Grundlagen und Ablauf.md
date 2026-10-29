---
typ: wissen
thema: AZ-802
tags: [az-802, jea, powershell, sicherheit]
aliases: [JEA Grundlagen, JEA Ablauf, JEA Voraussetzungen]
erstellt: 2026-10-29
status: lernen
---
# JEA 1 – Grundlagen und Ablauf

Übersicht: [[JEA Übersicht]] · Weiter: [[JEA Rollenfunktionsdatei]]

## Warum JEA?
| Ohne JEA | Mit JEA |
|---|---|
| Helpdesk ist Mitglied von *Administratoren* / *Domänen-Admins* | Helpdesk bleibt normaler Benutzer |
| kann **alles** (auch versehentlich) | kann **nur** freigegebene Befehle |
| Admin-Kennwort/Ticket liegt auf dem Helpdesk-PC → Diebstahl möglich | Admin-Rechte nur **temporär** im virtuellen Konto auf dem Zielserver |
| kaum nachvollziehbar, wer was tat | **Transkript** jeder Sitzung + PowerShell-Protokolle |
Prinzip: **Least Privilege** (geringste Rechte) – passt zum Tier-Modell → [[AZ-802 6 Sicherheit]].

## Ablauf einer JEA-Sitzung
1. Benutzer verbindet sich: `Enter-PSSession -ComputerName EXA-SRV01 -ConfigurationName DnsOperator`.
2. WinRM prüft: Darf der Benutzer den Endpunkt nutzen? (Gruppen aus **RoleDefinitions**, ggf. **RequiredGroups**)
3. JEA sucht die zugeordneten **Rollenfunktionen** (`.psrc`) und baut daraus die erlaubte Befehlsliste (mehrere Rollen = **Vereinigung**).
4. Sitzung startet im **NoLanguage**-Modus unter dem **RunAs-Konto** (virtuelles Konto oder gMSA).
5. Benutzer sieht mit `Get-Command` nur die erlaubten Befehle; alles wird ins **Transkript** geschrieben.
6. Beim Beenden wird das virtuelle Konto verworfen.

## Voraussetzungen
| Punkt | Anforderung |
|---|---|
| PowerShell | **5.0 oder neuer** (Windows PowerShell 5.1 auf Server 2016+ vorhanden) |
| Remoting | **WinRM** aktiv: `Enable-PSRemoting` (auf Servern Standard) – JEA funktioniert **nicht** über SSH-Remoting |
| Rechte zum Einrichten | lokaler Administrator auf dem Zielserver |
| Benutzer | Domänengruppen für die Rollen-Zuordnung (z. B. `EXAMPLE\GG_DNS-Operatoren`) |
| Optional | gMSA (Netzwerkzugriff), DSC für viele Server, Windows Admin Center |

```powershell
# Maschine: EXA-SRV01 – Voraussetzungen prüfen
$PSVersionTable.PSVersion
Get-Service WinRM
Get-PSSessionConfiguration | Format-Table Name, Permission -AutoSize
```

## Begriffe
| Begriff | Bedeutung |
|---|---|
| Endpunkt / Sitzungskonfiguration | benannter Remoting-Zugang (`-ConfigurationName`) → [[JEA Sitzungskonfiguration]] |
| Rollenfunktion | Liste erlaubter Befehle → [[JEA Rollenfunktionsdatei]] |
| RunAs-Konto | Konto, unter dem die Befehle laufen → [[JEA RunAs-Konten]] |
| NoLanguage-Modus | keine Skriptsprache: keine Variablen, Schleifen, Skriptblöcke |
| Transkript | Textprotokoll jeder Sitzung → [[JEA Sicherheit und Überwachung]] |

## Prüfungsfrage
Ein Benutzer ist in keiner Admin-Gruppe, kann aber per JEA den DNS-Dienst neu starten. Unter welchem Konto läuft `Restart-Service` – und warum ist das sicherer?

> [!success]- Lösung
> Unter dem **RunAs-Konto** (meist virtuelles Konto, lokaler Admin nur für diese Sitzung). Der Benutzer bekommt selbst keine Admin-Rechte, seine Anmeldedaten sind keine Admin-Daten und er kann nur die freigegebenen Befehle nutzen.

## Quellen
- [JEA Prerequisites – Microsoft Learn](https://learn.microsoft.com/powershell/scripting/security/remoting/jea/prerequisites)
- [Just Enough Administration – Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/jea/overview)
