---
title: "Übungsklausur 1 – Windows Server 2022"
tags:
  - klausur
  - windows-server
  - ad-ds
  - ad-cs
  - ad-fs
  - netzwerk
thema: Windows Server 2022
bearbeitungszeit: 90 min
punkte: 100
status: offen
ergebnis:
datum:
---
# Übungsklausur 1 – Windows Server 2022

Zurück zur Übersicht: [[Übungsklausuren – Übersicht]]

> [!info] Hinweise
> - Bearbeitungszeit: **90 Minuten**, Hilfsmittel: keine
> - 40 Aufgaben à **2,5 Punkte** = 100 Punkte
> - Teil A: Multiple Choice, genau eine Antwort richtig (Kästchen anhaken)
> - Teil B: Eingabeaufgaben, Antwort hinter „Antwort:“ eintragen
> - Lösungen sind eingeklappt. Erst nach der Bearbeitung aufklappen.

## Teil A – Multiple Choice (35 Aufgaben)

### AD DS – Domänendienste

**Aufgabe 1** · 2,5 P.

Wie viele Domänencontroller sollten pro Domäne in einer Produktivumgebung mindestens vorhanden sein?

- [ ] A) Einer
- [ ] B) Zwei
- [ ] C) Drei
- [ ] D) Fünf

> [!success]- Lösung Aufgabe 1
> **B)** Zwei
>
> Mindestens zwei DCs für Ausfallsicherheit.

---

**Aufgabe 2** · 2,5 P.

Welches Werkzeug prüft die allgemeine Integrität eines Domänencontrollers?

- [ ] A) chkdsk
- [ ] B) sfc /scannow
- [ ] C) dcdiag
- [ ] D) msinfo32

> [!success]- Lösung Aufgabe 2
> **C)** dcdiag
>
> dcdiag führt Integritäts- und Funktionstests des DCs durch.

---

**Aufgabe 3** · 2,5 P.

Sie setzen für die Benutzerin Anna ein neues Startkennwort. Sie soll es bei der nächsten Anmeldung selbst ändern müssen.

**Frage:** Wie erreichen Sie das?

- [ ] A) Das Konto deaktivieren
- [ ] B) Das Konto in die Gruppe Domänen-Admins aufnehmen
- [ ] C) Die Option "Benutzer muss Kennwort bei der nächsten Anmeldung ändern" aktivieren (Set-ADUser -ChangePasswordAtLogon $true)
- [ ] D) Das Kennwort auf "läuft nie ab" setzen

> [!success]- Lösung Aufgabe 3
> **C)** Die Option "Benutzer muss Kennwort bei der nächsten Anmeldung ändern" aktivieren (Set-ADUser -ChangePasswordAtLogon $true)
>
> Die Option erzwingt die Kennwortänderung bei der nächsten Anmeldung.

---

**Aufgabe 4** · 2,5 P.

Ein Mitarbeiter verlässt die Firma. Seine Postfach- und Dateidaten werden noch benötigt, und die Konto-SID muss für Berechtigungsanalysen erhalten bleiben. Er soll sich nicht mehr anmelden können.

**Frage:** Was ist das empfohlene Vorgehen?

- [ ] A) Konto deaktivieren (Disable-ADAccount), Gruppenmitgliedschaften prüfen und in eine [[OU]] "Deaktiviert" verschieben
- [ ] B) Konto sofort löschen
- [ ] C) Konto unverändert lassen und das Kennwort raten lassen
- [ ] D) Die Domäne neu aufsetzen

> [!success]- Lösung Aufgabe 4
> **A)** Konto deaktivieren (Disable-ADAccount), Gruppenmitgliedschaften prüfen und in eine OU "Deaktiviert" verschieben
>
> Deaktivieren erhält das Objekt samt [[SID]] und verhindert Anmeldungen; Löschen kann später erfolgen.

---

**Aufgabe 5** · 2,5 P.

Welche Verzeichnispartitionen werden auf alle DCs der gesamten Gesamtstruktur repliziert?

- [ ] A) Domänen- und Konfigurationspartition
- [ ] B) Schema- und Konfigurationspartition
- [ ] C) Nur die Schemapartition
- [ ] D) Nur die Domänenpartition

> [!success]- Lösung Aufgabe 5
> **B)** Schema- und Konfigurationspartition
>
> Schema- und Konfigurationspartition gibt es gesamtstrukturweit auf allen DCs.

---

**Aufgabe 6** · 2,5 P.

Wofür nutzen Sie den Assistenten "Objektverwaltung zuweisen" (Delegierung)?

- [ ] A) Zum Installieren neuer DCs
- [ ] B) Um bestimmten Benutzern oder Gruppen begrenzte Verwaltungsrechte auf eine OU zu geben, z. B. Kennwörter zurücksetzen
- [ ] C) Zum Anheben der Funktionsebene
- [ ] D) Zum Sichern der Datenbank

> [!success]- Lösung Aufgabe 6
> **B)** Um bestimmten Benutzern oder Gruppen begrenzte Verwaltungsrechte auf eine OU zu geben, z. B. Kennwörter zurücksetzen
>
> Die Delegierung gibt gezielt begrenzte Rechte, z. B. Kennwortzurücksetzung.

---

**Aufgabe 7** · 2,5 P.

Ein Server steht in einem Raum ohne ausreichenden physischen Schutz. Er soll lokale Anmeldungen ermöglichen, aber das Risiko eines Kennwort-Diebstahls minimieren.

**Frage:** Welche [[AD]]-Lösung ist am besten geeignet?

- [ ] A) Ein zusätzlicher vollwertiger [[DC]] mit allen [[FSMO]]-Rollen
- [ ] B) Ein schreibgeschützter Domänencontroller ([[RODC]]) mit eingeschränkter Kennwortreplikation
- [ ] C) Ein Mitgliedsserver mit lokalem Administratorkonto
- [ ] D) Ein zweiter [[DNS]]-Server ohne AD

> [!success]- Lösung Aufgabe 7
> **B)** Ein schreibgeschützter Domänencontroller (RODC) mit eingeschränkter Kennwortreplikation
>
> Ein RODC speichert keine Kennwörter, sofern nicht per Richtlinie erlaubt, und nimmt keine Änderungen an.

---

**Aufgabe 8** · 2,5 P.

In der Gesamtstruktur mit drei Domänen sind Anmeldungen und gesamtstrukturweite Suchen langsam. Nur ein DC ist als Globaler Katalog konfiguriert; er ist überlastet.

**Frage:** Wie verbessern Sie die Situation?

- [ ] A) Weitere DCs als Globalen Katalog konfigurieren
- [ ] B) Den Globalen Katalog deaktivieren
- [ ] C) Alle Benutzer in eine OU verschieben
- [ ] D) Die Funktionsebene absenken

> [!success]- Lösung Aufgabe 8
> **A)** Weitere DCs als Globalen Katalog konfigurieren
>
> Mehrere GC-Server erhöhen Verfügbarkeit und Leistung bei Anmeldungen (universelle Gruppen) und Suchen.

---

**Aufgabe 9** · 2,5 P.

Ein DC war 200 Tage vom Netz getrennt (Lager). Er soll wieder ins Netzwerk. Die Tombstone-Lebensdauer beträgt den Standardwert.

**Frage:** Was ist zu tun?

- [ ] A) Nicht ans Netz nehmen (Gefahr veralteter Objekte), Metadaten bereinigen und den Server neu heraufstufen
- [ ] B) Einfach anschließen, die Replikation regelt alles
- [ ] C) Nur den Zeitdienst neu starten
- [ ] D) gpupdate /force ausführen

> [!success]- Lösung Aufgabe 9
> **A)** Nicht ans Netz nehmen (Gefahr veralteter Objekte), Metadaten bereinigen und den Server neu heraufstufen
>
> Die Standard-Tombstone-Lebensdauer beträgt 180 Tage; ein länger getrennter DC führt zu lingering objects und darf nicht replizieren.

---

**Aufgabe 10** · 2,5 P.

Welche FSMO-Rollen existieren genau einmal pro Gesamtstruktur?

- [ ] A) [[PDC]]-Emulator und [[RID]]-Master
- [ ] B) Schemamaster und Domänennamenmaster
- [ ] C) Infrastrukturmaster und RID-Master
- [ ] D) Alle fünf Rollen

> [!success]- Lösung Aufgabe 10
> **B)** Schemamaster und Domänennamenmaster
>
> Schemamaster und Domänennamenmaster gibt es einmal pro Gesamtstruktur, die anderen drei je Domäne.

---

**Aufgabe 11** · 2,5 P.

Was ist die Hauptaufgabe der Active Directory-Domänendienste ([[AD DS]])?

- [ ] A) Bereitstellung von Dateifreigaben
- [ ] B) Zentrale Verwaltung von Identitäten, Authentifizierung und Autorisierung
- [ ] C) Automatische Vergabe von [[IP]]-Adressen
- [ ] D) Hosting von Webanwendungen

> [!success]- Lösung Aufgabe 11
> **B)** Zentrale Verwaltung von Identitäten, Authentifizierung und Autorisierung
>
> AD DS ist der Verzeichnisdienst für Identitäten, Authentifizierung und Autorisierung.

---

**Aufgabe 12** · 2,5 P.

Mit welchem Befehl prüfen Sie den Replikationsstatus aller DCs übersichtlich?

- [ ] A) repadmin /replsummary
- [ ] B) ping -r
- [ ] C) gpupdate /repl
- [ ] D) netstat -ad

> [!success]- Lösung Aufgabe 12
> **A)** repadmin /replsummary
>
> repadmin /replsummary fasst den Replikationsstatus zusammen.

---

**Aufgabe 13** · 2,5 P.

Mit welchem Cmdlet fügen Sie einen weiteren Domänencontroller zu einer vorhandenen Domäne hinzu?

- [ ] A) Install-ADDSForest
- [ ] B) Add-ADDomainController
- [ ] C) Install-ADDSDomainController
- [ ] D) New-ADDomainController

> [!success]- Lösung Aufgabe 13
> **C)** Install-ADDSDomainController
>
> Install-ADDSDomainController fügt einen DC zu einer bestehenden Domäne hinzu.

---

**Aufgabe 14** · 2,5 P.

Wofür wird das DSRM-Kennwort (Verzeichnisdienste-Wiederherstellungsmodus) benötigt?

- [ ] A) Für die Anmeldung des Domänen-Administrators am Client
- [ ] B) Für den Offline-Start des DC im Wiederherstellungsmodus
- [ ] C) Für die Replikation zwischen DCs
- [ ] D) Für den Betrieb des DNS-Servers

> [!success]- Lösung Aufgabe 14
> **B)** Für den Offline-Start des DC im Wiederherstellungsmodus
>
> DSRM ist der Offline-Wiederherstellungsmodus mit eigenem lokalem Kennwort.

---

**Aufgabe 15** · 2,5 P.

Was beschreibt der Distinguished Name (DN) eines Objekts?

- [ ] A) Den Netzwerkpfad zu einer Freigabe
- [ ] B) Den eindeutigen Pfad des Objekts im Verzeichnis, z. B. CN=Max Muster,OU=Vertrieb,DC=contoso,DC=com
- [ ] C) Den Anmeldenamen im Format user@domain
- [ ] D) Die SID des Objekts

> [!success]- Lösung Aufgabe 15
> **B)** Den eindeutigen Pfad des Objekts im Verzeichnis, z. B. CN=Max Muster,OU=Vertrieb,DC=contoso,DC=com
>
> Der DN ist der eindeutige Verzeichnispfad des Objekts.

---

**Aufgabe 16** · 2,5 P.

Im Vertrieb (50 Personen) sollen die Berechtigungen auf einem Datei-Share vergeben werden. Mitarbeiter wechseln häufig die Abteilung, und der Aufwand für Änderungen soll gering bleiben.

**Frage:** Welches Vorgehen entspricht der Best Practice?

- [ ] A) Benutzerkonten in globale Gruppen aufnehmen, globale Gruppen in domänenlokale Gruppen, Berechtigungen der domänenlokalen Gruppe erteilen ([[AGDLP]])
- [ ] B) Jedem Benutzer direkt Berechtigungen auf den Share geben
- [ ] C) Alle Benutzer in die Gruppe Domänen-Admins aufnehmen
- [ ] D) Eine Verteilergruppe mit den Berechtigungen versehen

> [!success]- Lösung Aufgabe 16
> **A)** Benutzerkonten in globale Gruppen aufnehmen, globale Gruppen in domänenlokale Gruppen, Berechtigungen der domänenlokalen Gruppe erteilen (AGDLP)
>
> AGDLP reduziert den Aufwand: Bei Wechseln wird nur die Gruppenmitgliedschaft angepasst.

---

### Netzwerk – IPv4/IPv6, Routing, DNS, DHCP

**Aufgabe 17** · 2,5 P.

Clients im Büro erhalten plötzlich das Standardgateway 192.168.0.1 und einen unbekannten DNS-Server, obwohl der zentrale [[DHCP]]-Server (10.0.0.1) andere Werte verteilt. Ein Mitarbeiter hat einen privaten [[WLAN]]-Router am Netzwerk angeschlossen.

**Frage:** Was ist die Ursache und Gegenmaßnahme?

- [ ] A) Der DNS-Cache der Clients ist beschädigt
- [ ] B) Der Bereich des zentralen Servers ist zu klein
- [ ] C) Ein nicht autorisierter DHCP-Server (Rogue-DHCP) im Netz; Gerät entfernen und DHCP-Snooping auf den Switches aktivieren
- [ ] D) Die [[Kerberos]]-Zeit weicht ab

> [!success]- Lösung Aufgabe 17
> **C)** Ein nicht autorisierter DHCP-Server (Rogue-DHCP) im Netz; Gerät entfernen und DHCP-Snooping auf den Switches aktivieren
>
> Ein privater Router mit aktivem DHCP antwortet schneller und verteilt falsche Einstellungen.

---

**Aufgabe 18** · 2,5 P.

Im Netz erhalten Clients per Router-Advertisement (SLAAC) [[IPv6]]-Adressen, aber keine DNS-Serverinformationen.

**Frage:** Wie lösen Sie das Problem?

- [ ] A) Den IPv6-Stack deaktivieren
- [ ] B) Zustandsloses DHCPv6 einrichten (bzw. RDNSS im Router-Advertisement), damit DNS-Optionen verteilt werden
- [ ] C) Alle Adressen manuell vergeben
- [ ] D) Den Router neu starten

> [!success]- Lösung Aufgabe 18
> **B)** Zustandsloses DHCPv6 einrichten (bzw. RDNSS im Router-Advertisement), damit DNS-Optionen verteilt werden
>
> Bei SLAAC liefert zustandsloses DHCPv6 zusätzliche Optionen wie DNS-Server.

---

**Aufgabe 19** · 2,5 P.

Zwei DNS-Server verwalten die Zone contoso.local: DNS01 (primär) und DNS02 (sekundär). Änderungen am Primärserver erscheinen auf DNS02 nicht.

**Frage:** Was prüfen Sie?

- [ ] A) Die Uhrzeit der Clients
- [ ] B) Die DHCP-Lease-Dauer
- [ ] C) Die Zonenübertragung (Übertragung an DNS02 erlaubt?) und die Seriennummer der Zone
- [ ] D) Die Größe der Auslagerungsdatei

> [!success]- Lösung Aufgabe 19
> **C)** Die Zonenübertragung (Übertragung an DNS02 erlaubt?) und die Seriennummer der Zone
>
> Sekundärserver erhalten Änderungen per Zonenübertragung; die Seriennummer muss erhöht werden.

---

**Aufgabe 20** · 2,5 P.

Ein Server hat zwei Netzwerkkarten: [[LAN]] (192.168.1.0/24) und [[WAN]] mit öffentlicher IP-Adresse. Alle LAN-Clients sollen über diesen Server ins Internet gelangen. Eine separate Hardware-Firewall ist nicht vorhanden.

**Frage:** Was konfigurieren Sie?

- [ ] A) Einen DHCP-Relay-Agent auf der WAN-Karte
- [ ] B) Die Rolle Remotezugriff mit dem Rollendienst Routing installieren, [[NAT]] auf der WAN-Schnittstelle einrichten und den Server als Standardgateway der Clients eintragen
- [ ] C) Eine DNS-Weiterleitung auf 127.0.0.1
- [ ] D) IP-Forwarding auf allen Karten deaktivieren

> [!success]- Lösung Aufgabe 20
> **B)** Die Rolle Remotezugriff mit dem Rollendienst Routing installieren, NAT auf der WAN-Schnittstelle einrichten und den Server als Standardgateway der Clients eintragen
>
> Ein Router mit NAT übersetzt die privaten Adressen in die öffentliche Adresse; die Clients nutzen ihn als Gateway.

---

**Aufgabe 21** · 2,5 P.

Wie lang ist eine IPv6-Adresse?

- [ ] A) 128 Bit
- [ ] B) 64 Bit
- [ ] C) 32 Bit
- [ ] D) 256 Bit

> [!success]- Lösung Aufgabe 21
> **A)** 128 Bit
>
> IPv6-Adressen haben 128 Bit ([[IPv4]]: 32 Bit).

---

**Aufgabe 22** · 2,5 P.

Wie lange beträgt die Standard-Lease-Dauer eines DHCP-Bereichs (kabelgebunden) unter Windows Server?

- [ ] A) 1 Tag
- [ ] B) 8 Tage
- [ ] C) 30 Tage
- [ ] D) 1 Stunde

> [!success]- Lösung Aufgabe 22
> **B)** 8 Tage
>
> Der Standardwert für Bereiche beträgt 8 Tage.

---

**Aufgabe 23** · 2,5 P.

Was bietet DHCP-Failover ab Windows Server 2012?

- [ ] A) Hochverfügbarkeit für einen Bereich zwischen zwei DHCP-Servern (Lastenausgleich oder Hot-Standby)
- [ ] B) Automatische IP-Vergabe ohne Server
- [ ] C) Verschlüsselung von DHCP-Paketen
- [ ] D) Ersatz für DNS

> [!success]- Lösung Aufgabe 23
> **A)** Hochverfügbarkeit für einen Bereich zwischen zwei DHCP-Servern (Lastenausgleich oder Hot-Standby)
>
> Zwei Server können einen Bereich gemeinsam bereitstellen, im Lastenausgleich oder als Hot-Standby.

---

**Aufgabe 24** · 2,5 P.

Ein Windows Server 2022 hat zwei Netzwerkkarten: LAN (10.1.0.5/24) und [[DMZ]] (10.2.0.5/24). Er soll den Verkehr zwischen beiden Netzen weiterleiten.

**Frage:** Was tun Sie?

- [ ] A) Nichts, Windows routet standardmäßig
- [ ] B) Zwei Standardgateways auf beiden Karten eintragen
- [ ] C) Die DNS-Rolle installieren
- [ ] D) Routing aktivieren (Set-NetIPInterface -Forwarding Enabled bzw. Rolle Remotezugriff/Routing) und auf den Clients den Server als Gateway bzw. Route eintragen

> [!success]- Lösung Aufgabe 24
> **D)** Routing aktivieren (Set-NetIPInterface -Forwarding Enabled bzw. Rolle Remotezugriff/Routing) und auf den Clients den Server als Gateway bzw. Route eintragen
>
> IP-Forwarding muss aktiviert werden, und die Clients müssen den Router als Gateway nutzen.

---

**Aufgabe 25** · 2,5 P.

Mit welcher Serverrolle lässt sich Windows Server 2022 als Router (LAN-Routing) betreiben?

- [ ] A) DHCP-Server
- [ ] B) Remotezugriff mit Rollendienst Routing
- [ ] C) Hyper-V
- [ ] D) [[WSUS]]

> [!success]- Lösung Aufgabe 25
> **B)** Remotezugriff mit Rollendienst Routing
>
> Die Rolle Remotezugriff enthält den Rollendienst Routing.

---

**Aufgabe 26** · 2,5 P.

Eine Anwendung funktioniert nur mit IPv4, und ein Kollege möchte IPv6 auf dem Server über die Registry deaktivieren.

**Frage:** Was ist die bessere Empfehlung?

- [ ] A) IPv6 vollständig deaktivieren und Komponenten entfernen
- [ ] B) IPv6 deaktivieren und Firewall abschalten
- [ ] C) IPv6 aktiviert lassen und nur die Anwendung/Namensauflösung auf IPv4 ausrichten (ggf. IPv4 bei der Präfixrichtlinie bevorzugen)
- [ ] D) Den Server auf Windows Server 2008 zurücksetzen

> [!success]- Lösung Aufgabe 26
> **C)** IPv6 aktiviert lassen und nur die Anwendung/Namensauflösung auf IPv4 ausrichten (ggf. IPv4 bei der Präfixrichtlinie bevorzugen)
>
> Microsoft rät davon ab, IPv6 vollständig zu deaktivieren; die IPv4-Bevorzugung ist die gezielte Alternative.

---

### AD CS – Zertifikatdienste

**Aufgabe 27** · 2,5 P.

Für einen Webserver soll ein Zertifikat mit mehreren DNS-Namen (Subject Alternative Names) ausgestellt werden. Der Antragsteller möchte die Namen selbst in der Anforderung angeben.

**Frage:** Wie konfigurieren Sie die Vorlage?

- [ ] A) Die Vorlage muss den Namen aus AD beziehen
- [ ] B) Die Vorlage darf nur für Benutzer gelten
- [ ] C) Der Name lässt sich nachträglich nicht ändern
- [ ] D) Vorlage duplizieren, im Antragstellernamen "Angabe in der Anforderung" aktivieren und nur berechtigten Gruppen das Registrieren erlauben

> [!success]- Lösung Aufgabe 27
> **D)** Vorlage duplizieren, im Antragstellernamen "Angabe in der Anforderung" aktivieren und nur berechtigten Gruppen das Registrieren erlauben
>
> Für Webserver-Zertifikate wird der Antragstellername häufig in der Anforderung angegeben; der Zugriff sollte eingeschränkt werden.

---

**Aufgabe 28** · 2,5 P.

Ein Unternehmen baut eine neue [[PKI]] auf und legt Wert auf maximale Sicherheit des Stammzertifikats. Ausgestellt werden sollen Zertifikate für Server, Clients und Benutzer im Active Directory.

**Frage:** Welche Konzeption ist am besten geeignet?

- [ ] A) Eine Enterprise-Root-CA auf einem Domänencontroller, die alle Zertifikate ausstellt
- [ ] B) Eine Offline-Standalone-Root-CA und eine untergeordnete Enterprise-CA, die im Alltag Zertifikate ausstellt
- [ ] C) Zwei Enterprise-Root-CAs ohne Hierarchie
- [ ] D) Eine Standalone-CA, die ständig online ist und alles ausstellt

> [!success]- Lösung Aufgabe 28
> **B)** Eine Offline-Standalone-Root-CA und eine untergeordnete Enterprise-CA, die im Alltag Zertifikate ausstellt
>
> Ein zweistufiges Modell schützt den Root-Schlüssel offline; die untergeordnete Enterprise-CA nutzt AD und Vorlagen.

---

**Aufgabe 29** · 2,5 P.

Ab welcher Schemaversion der Zertifikatvorlage ist Autoenrollment möglich?

- [ ] A) Ab Version 2
- [ ] B) Nur Version 1
- [ ] C) Nur Version 4
- [ ] D) Autoenrollment ist nicht von der Version abhängig

> [!success]- Lösung Aufgabe 29
> **A)** Ab Version 2
>
> Vorlagen der Version 1 unterstützen kein Autoenrollment; ab Version 2 ist es möglich.

---

**Aufgabe 30** · 2,5 P.

Wie lauten die Standardintervalle für die Veröffentlichung von CRLs auf einer Windows-CA?

- [ ] A) Basis-CRL täglich, Delta-CRL stündlich
- [ ] B) Basis-CRL wöchentlich, Delta-CRL täglich
- [ ] C) Basis-CRL monatlich, keine Delta-CRL
- [ ] D) Beide alle 5 Minuten

> [!success]- Lösung Aufgabe 30
> **B)** Basis-CRL wöchentlich, Delta-CRL täglich
>
> Standard: Basis-CRL 1 Woche, Delta-CRL 1 Tag.

---

**Aufgabe 31** · 2,5 P.

Was kennzeichnet eine Stammzertifizierungsstelle (Root [[CA]])?

- [ ] A) Sie besitzt ein selbstsigniertes Zertifikat und ist der Vertrauensanker der Hierarchie
- [ ] B) Sie stellt nur Zertifikate für Endbenutzer aus
- [ ] C) Sie muss immer online sein
- [ ] D) Sie erhält ihr Zertifikat von einer untergeordneten CA

> [!success]- Lösung Aufgabe 31
> **A)** Sie besitzt ein selbstsigniertes Zertifikat und ist der Vertrauensanker der Hierarchie
>
> Das Zertifikat der Root CA ist selbstsigniert; ihm wird vertraut, weil es in den Vertrauensspeichern verteilt ist.

---

**Aufgabe 32** · 2,5 P.

Zertifikate für Benutzer laufen in 30 Tagen ab. Sie möchten, dass sie ohne Benutzereingriff erneuert werden.

**Frage:** Was konfigurieren Sie?

- [ ] A) Autoenrollment für die Vorlage (Benutzerkonfiguration per [[GPO]]) und einen passenden Erneuerungszeitraum in der Vorlage
- [ ] B) Die Gültigkeitsdauer auf 1 Tag setzen
- [ ] C) Die CA-Datenbank zurücksetzen
- [ ] D) Alle Benutzer neu anlegen

> [!success]- Lösung Aufgabe 32
> **A)** Autoenrollment für die Vorlage (Benutzerkonfiguration per GPO) und einen passenden Erneuerungszeitraum in der Vorlage
>
> Bei aktivem Autoenrollment werden Zertifikate im Erneuerungszeitraum automatisch erneuert.

---

### AD FS & Webanwendungsproxy

**Aufgabe 33** · 2,5 P.

Worin unterscheidet sich die AD FS-Vorauthentifizierung von der Pass-Through-Vorauthentifizierung im WAP?

- [ ] A) Bei der AD FS-Vorauthentifizierung wird der Benutzer bereits am WAP über AD FS authentifiziert, bevor Datenverkehr an die Anwendung weitergeleitet wird; bei Pass-Through übernimmt die Anwendung die Authentifizierung
- [ ] B) Es gibt keinen Unterschied
- [ ] C) Pass-Through ist sicherer als AD FS-Vorauthentifizierung
- [ ] D) Die AD FS-Vorauthentifizierung funktioniert nur intern

> [!success]- Lösung Aufgabe 33
> **A)** Bei der AD FS-Vorauthentifizierung wird der Benutzer bereits am WAP über AD FS authentifiziert, bevor Datenverkehr an die Anwendung weitergeleitet wird; bei Pass-Through übernimmt die Anwendung die Authentifizierung
>
> Mit Vorauthentifizierung gelangt nur authentifizierter Datenverkehr in das interne Netz.

---

**Aufgabe 34** · 2,5 P.

Welche Aufgabe hat der Webanwendungsproxy (WAP)?

- [ ] A) Er repliziert die AD-Datenbank
- [ ] B) Er vergibt IP-Adressen
- [ ] C) Er löst DNS-Namen auf
- [ ] D) Er fungiert als Reverse-Proxy, veröffentlicht interne Webanwendungen und den AD FS-Dienst sicher für externe Clients (mit Vorauthentifizierung)

> [!success]- Lösung Aufgabe 34
> **D)** Er fungiert als Reverse-Proxy, veröffentlicht interne Webanwendungen und den AD FS-Dienst sicher für externe Clients (mit Vorauthentifizierung)
>
> Der WAP ist ein Rollendienst der Rolle Remotezugriff und wird typischerweise in der DMZ betrieben.

---

**Aufgabe 35** · 2,5 P.

Mit welchem Cmdlet konfigurieren Sie den Webanwendungsproxy nach der Installation?

- [ ] A) Install-AdfsFarm
- [ ] B) Install-WebApplicationProxy
- [ ] C) Add-WapServer
- [ ] D) Enable-WebProxy

> [!success]- Lösung Aufgabe 35
> **B)** Install-WebApplicationProxy
>
> Install-WebApplicationProxy verbindet den WAP mit dem Verbunddienst (FederationServiceName, Zertifikat, Anmeldeinformationen).

---

## Teil B – Eingabeaufgaben (5 Aufgaben)

**Aufgabe 36** · 2,5 P. · *[[AD CS]] – Zertifikatdienste*

Mit welchem Snap-In (Dateiname .msc) verwalten Sie die Zertifikate des lokalen Computers?
(Eingabe, z. B. xyz.msc)

Antwort: 

> [!success]- Lösung Aufgabe 36
> **certlm.msc**
>
> certlm.msc zeigt den Computerspeicher, certmgr.msc den Benutzerspeicher.

---

**Aufgabe 37** · 2,5 P. · *Netzwerk – IPv4/IPv6, Routing, DNS, DHCP*

Wie lautet die Broadcastadresse des Hosts 192.168.10.70/26?
(Adresse eingeben)

Antwort: 

> [!success]- Lösung Aufgabe 37
> **192.168.10.127**
>
> Das Netz ist 192.168.10.64/26 (64–127); die Broadcastadresse ist .127.

---

**Aufgabe 38** · 2,5 P. · *AD DS – Domänendienste*

Wie heißt die Datenbankdatei des Active Directory auf einem Domänencontroller?
(Dateiname eingeben)

Antwort: 

> [!success]- Lösung Aufgabe 38
> **NTDS.dit**
>
> Die AD-Datenbank ist NTDS.dit (Standard: C:\Windows\NTDS).

---

**Aufgabe 39** · 2,5 P. · *Netzwerk – IPv4/IPv6, Routing, DNS, DHCP*

Welches Präfix kennzeichnet IPv6-Link-Local-Adressen?
(Eingabe, z. B. 2000::/3)

Antwort: 

> [!success]- Lösung Aufgabe 39
> **fe80::/10**
>
> fe80::/10 ist Link-Local; fc00::/7 sind Unique-Local, 2000::/3 globale Unicast, ff00::/8 Multicast.

---

**Aufgabe 40** · 2,5 P. · *Netzwerk – IPv4/IPv6, Routing, DNS, DHCP*

Welche Adresse ist die IPv6-Loopback-Adresse?
(Adresse eingeben)

Antwort: 

> [!success]- Lösung Aufgabe 40
> **::1**
>
> ::1 ist Loopback (entspricht 127.0.0.1); :: ist die unspezifizierte Adresse.

---

## Auswertung

> [!check]- Lösungsschlüssel
> | Nr. | Lösung | Thema |
> |---|---|---|
> | 1 | B | AD DS |
> | 2 | C | AD DS |
> | 3 | C | AD DS |
> | 4 | A | AD DS |
> | 5 | B | AD DS |
> | 6 | B | AD DS |
> | 7 | B | AD DS |
> | 8 | A | AD DS |
> | 9 | A | AD DS |
> | 10 | B | AD DS |
> | 11 | B | AD DS |
> | 12 | A | AD DS |
> | 13 | C | AD DS |
> | 14 | B | AD DS |
> | 15 | B | AD DS |
> | 16 | A | AD DS |
> | 17 | C | Netzwerk |
> | 18 | B | Netzwerk |
> | 19 | C | Netzwerk |
> | 20 | B | Netzwerk |
> | 21 | A | Netzwerk |
> | 22 | B | Netzwerk |
> | 23 | A | Netzwerk |
> | 24 | D | Netzwerk |
> | 25 | B | Netzwerk |
> | 26 | C | Netzwerk |
> | 27 | D | AD CS |
> | 28 | B | AD CS |
> | 29 | A | AD CS |
> | 30 | B | AD CS |
> | 31 | A | AD CS |
> | 32 | A | AD CS |
> | 33 | A | AD FS & Webanwendungsproxy |
> | 34 | D | AD FS & Webanwendungsproxy |
> | 35 | B | AD FS & Webanwendungsproxy |
> | 36 | certlm.msc | AD CS |
> | 37 | 192.168.10.127 | Netzwerk |
> | 38 | NTDS.dit | AD DS |
> | 39 | fe80::/10 | Netzwerk |
> | 40 | ::1 | Netzwerk |

| Richtige Aufgaben | Punkte | Note (IHK) |
|---|---|---|
| 37–40 | 92,5–100 | 1 – sehr gut |
| 33–36 | 82,5–90 | 2 – gut |
| 27–32 | 67,5–80 | 3 – befriedigend |
| 20–26 | 50–65 | 4 – ausreichend |
| 12–19 | 30–47,5 | 5 – mangelhaft |
| 0–11 | 0–27,5 | 6 – ungenügend |

**Mein Ergebnis:** ___ / 40 richtig = ___ Punkte → Note ___

**Themen zum Wiederholen:**
- 
