---
title: "Übungsklausur 2 – Windows Server 2022"
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
# Übungsklausur 2 – Windows Server 2022

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

Mit welchem Cmdlet erstellen Sie eine neue untergeordnete Domäne in einer bestehenden Gesamtstruktur?

- [ ] A) Install-ADDSDomain
- [ ] B) Install-ADDSForest
- [ ] C) New-ADDomain
- [ ] D) Add-ADDomain

> [!success]- Lösung Aufgabe 1
> **A)** Install-ADDSDomain
>
> Install-ADDSDomain erstellt eine untergeordnete oder neue Baumdomäne.

---

**Aufgabe 2** · 2,5 P.

Ein virtualisierter Domänencontroller (Hyper-V) wird nach einem fehlerhaften Update aus einer alten Momentaufnahme (Snapshot) zurückgesetzt. Sie befürchten Replikationsprobleme (USN-Rollback).

**Frage:** Welche Technik schützt Windows Server 2022 dabei?

- [ ] A) Der Papierkorb
- [ ] B) Die [[VM]]-Generation-ID, die der [[DC]] nach dem Zurücksetzen erkennt und sich sicher verhält (neue Invocation-ID, Neuabgleich von [[SYSVOL]])
- [ ] C) Das Protokoll [[DHCP]]
- [ ] D) Die Gruppenrichtlinie Standarddomänenrichtlinie

> [!success]- Lösung Aufgabe 2
> **B)** Die VM-Generation-ID, die der DC nach dem Zurücksetzen erkennt und sich sicher verhält (neue Invocation-ID, Neuabgleich von SYSVOL)
>
> Bei [[Hypervisor]]-Unterstützung erkennt der DC die geänderte VM-Generation-ID und schützt vor USN-Rollback. Snapshots sind dennoch keine Sicherung.

---

**Aufgabe 3** · 2,5 P.

Eine Gruppenrichtlinie mit Sicherheitsvorgaben ist mit der Domäne verknüpft. Der Administrator der [[OU]] "Labor" hat dort "Vererbung deaktivieren" gesetzt, wodurch die Richtlinie dort nicht gilt. Sie soll aber überall gelten.

**Frage:** Wie stellen Sie das sicher?

- [ ] A) Die OU löschen
- [ ] B) Die [[GPO]] in SYSVOL umbenennen
- [ ] C) gpupdate /force auf jedem Client ausführen
- [ ] D) Den Domänenlink der GPO auf "Erzwungen" (Enforced) setzen

> [!success]- Lösung Aufgabe 3
> **D)** Den Domänenlink der GPO auf "Erzwungen" (Enforced) setzen
>
> Erzwungene Verknüpfungen werden trotz blockierter Vererbung angewendet.

---

**Aufgabe 4** · 2,5 P.

Eine Gruppenrichtlinie ist mit der Domäne verknüpft. Computerkonten befinden sich noch im Standardcontainer "Computers". Auf eine neue GPO für diese Computer soll ein Skript laufen, doch sie wird nicht angewendet.

**Frage:** Was ist die Ursache und Lösung?

- [ ] A) Der Client hat kein Kennwort; Kennwort neu setzen
- [ ] B) GPOs lassen sich nicht auf Standardcontainer verknüpfen; Computerkonten in eine OU verschieben und die GPO dort verknüpfen
- [ ] C) Das Skript ist zu groß
- [ ] D) Die GPO muss im Ordner NETLOGON liegen

> [!success]- Lösung Aufgabe 4
> **B)** GPOs lassen sich nicht auf Standardcontainer verknüpfen; Computerkonten in eine OU verschieben und die GPO dort verknüpfen
>
> Auf die Container Users und Computers können keine GPOs verknüpft werden; Computer gehören in OUs (redircmp legt eine Standard-OU fest).

---

**Aufgabe 5** · 2,5 P.

Die Firma Contoso richtet erstmals Active Directory ein. Ein frisch installierter Windows Server 2022 (SRV01) ist bereits mit statischer [[IP]] konfiguriert und die Rolle [[AD DS]] ist installiert. Es existiert noch keine Domäne.

**Frage:** Welchen Befehl führen Sie aus, um contoso.local anzulegen?

- [ ] A) Install-ADDSDomainController -DomainName contoso.local
- [ ] B) Install-ADDSForest -DomainName contoso.local
- [ ] C) Install-ADDSDomain -NewDomainName contoso.local
- [ ] D) New-ADDomain -Name contoso.local

> [!success]- Lösung Aufgabe 5
> **B)** Install-ADDSForest -DomainName contoso.local
>
> Für die erste Domäne einer neuen Gesamtstruktur wird Install-ADDSForest verwendet.

---

**Aufgabe 6** · 2,5 P.

Welche Aufgabe hat der [[PDC]]-Emulator?

- [ ] A) Zeitsynchronisierung in der Domäne, Kennwortänderungen und Kontosperrungen
- [ ] B) Verwaltung des Schemas
- [ ] C) Aufnahme neuer Domänen
- [ ] D) Vergabe von IP-Adressen

> [!success]- Lösung Aufgabe 6
> **A)** Zeitsynchronisierung in der Domäne, Kennwortänderungen und Kontosperrungen
>
> Der PDC-Emulator ist Zeitquelle und bevorzugter DC bei Kennwortänderungen und Sperrungen.

---

**Aufgabe 7** · 2,5 P.

Ein Administrator möchte das Schema erweitern (neues Attribut). Der Vorgang scheitert mit "Zugriff verweigert", obwohl er Mitglied der Domänen-Admins ist.

**Frage:** Was ist die Ursache?

- [ ] A) Der Domänencontroller ist nicht im Netzwerk
- [ ] B) Der Globale Katalog fehlt
- [ ] C) Die Domänenfunktionsebene ist zu hoch
- [ ] D) Für Schemaänderungen ist die Mitgliedschaft in der Gruppe Schema-Admins erforderlich, und die Änderung muss am Schemamaster erfolgen

> [!success]- Lösung Aufgabe 7
> **D)** Für Schemaänderungen ist die Mitgliedschaft in der Gruppe Schema-Admins erforderlich, und die Änderung muss am Schemamaster erfolgen
>
> Schemaänderungen erfordern Schema-Admins-Rechte und werden über den Schemamaster ausgeführt.

---

**Aufgabe 8** · 2,5 P.

Mit welchem Snap-In fügen Sie zusätzliche [[UPN]]-Suffixe für die Gesamtstruktur hinzu?

- [ ] A) Active Directory-Domänen und -Vertrauensstellungen
- [ ] B) Active Directory-Benutzer und -Computer
- [ ] C) Gruppenrichtlinienverwaltung
- [ ] D) Serverbereitstellung

> [!success]- Lösung Aufgabe 8
> **A)** Active Directory-Domänen und -Vertrauensstellungen
>
> UPN-Suffixe verwalten Sie in domain.msc (Domänen und Vertrauensstellungen).

---

**Aufgabe 9** · 2,5 P.

Die Domäne läuft auf der Funktionsebene Windows Server 2012 R2. Alle DCs sind Windows Server 2019/2022, ein alter DC (2012 R2) ist noch vorhanden. Sie möchten auf Windows Server 2016 anheben.

**Frage:** Was ist die Voraussetzung?

- [ ] A) Alle Clients müssen Windows 11 nutzen
- [ ] B) Die Gesamtstruktur muss neu erstellt werden
- [ ] C) Alle DCs der Domäne müssen mindestens Windows Server 2016 sein; den alten DC vorher herabstufen und entfernen
- [ ] D) Der Globale Katalog muss deaktiviert sein

> [!success]- Lösung Aufgabe 9
> **C)** Alle DCs der Domäne müssen mindestens Windows Server 2016 sein; den alten DC vorher herabstufen und entfernen
>
> Die Funktionsebene kann nur angehoben werden, wenn alle DCs der Domäne das erforderliche Betriebssystem haben.

---

**Aufgabe 10** · 2,5 P.

Was unterscheidet Sicherheitsgruppen von Verteilergruppen?

- [ ] A) Verteilergruppen können Berechtigungen erhalten
- [ ] B) Sicherheitsgruppen können für Berechtigungen verwendet werden, Verteilergruppen nicht
- [ ] C) Sicherheitsgruppen können keine Mitglieder enthalten
- [ ] D) Es gibt keinen Unterschied

> [!success]- Lösung Aufgabe 10
> **B)** Sicherheitsgruppen können für Berechtigungen verwendet werden, Verteilergruppen nicht
>
> Nur Sicherheitsgruppen erhalten Berechtigungen; Verteilergruppen dienen z. B. dem E-Mail-Versand.

---

**Aufgabe 11** · 2,5 P.

Was bedeutet Multimaster-Replikation?

- [ ] A) Nur ein DC darf Änderungen annehmen
- [ ] B) Änderungen können auf jedem schreibbaren DC erfolgen und werden auf die anderen repliziert
- [ ] C) Alle DCs sind schreibgeschützt
- [ ] D) Änderungen werden nur manuell kopiert

> [!success]- Lösung Aufgabe 11
> **B)** Änderungen können auf jedem schreibbaren DC erfolgen und werden auf die anderen repliziert
>
> Jeder schreibbare DC nimmt Änderungen an und repliziert sie.

---

**Aufgabe 12** · 2,5 P.

Mit welchem Cmdlet erstellen Sie ein neues Benutzerkonto?

- [ ] A) Add-ADUser
- [ ] B) Create-ADUser
- [ ] C) New-LocalUser
- [ ] D) New-ADUser

> [!success]- Lösung Aufgabe 12
> **D)** New-ADUser
>
> New-ADUser legt Benutzerkonten an.

---

**Aufgabe 13** · 2,5 P.

Nach der Heraufstufung von DC01 kann ein Windows 11-Client die Domäne contoso.local nicht finden. In den IP-Einstellungen des Clients ist als [[DNS]]-Server 8.8.8.8 eingetragen.

**Frage:** Was ist die wahrscheinlichste Ursache und Lösung?

- [ ] A) Der Client benötigt die IP des DC als DNS-Server, weil nur dort die SRV-Einträge der Domäne liegen
- [ ] B) Der Client benötigt eine neuere Windows-Version
- [ ] C) Der DC muss zuerst neu gestartet werden, danach funktioniert jeder DNS-Server
- [ ] D) Die Domäne muss den Namen contoso.com tragen

> [!success]- Lösung Aufgabe 13
> **A)** Der Client benötigt die IP des DC als DNS-Server, weil nur dort die SRV-Einträge der Domäne liegen
>
> Domänenmitglieder müssen einen DNS-Server nutzen, der die [[AD]]-Zonen und SRV-Einträge kennt, in der Regel den DC.

---

**Aufgabe 14** · 2,5 P.

Wofür steht die Empfehlung [[AGDLP]]?

- [ ] A) Konten in globale Gruppen, diese in domänenlokale Gruppen, dort Berechtigungen vergeben
- [ ] B) Administratoren, Gruppen, Domänen, Lizenzen, Profile
- [ ] C) Konten direkt in Dateiberechtigungen eintragen
- [ ] D) Universelle Gruppen in lokale Benutzer

> [!success]- Lösung Aufgabe 14
> **A)** Konten in globale Gruppen, diese in domänenlokale Gruppen, dort Berechtigungen vergeben
>
> Account, Global, Domain Local, Permission.

---

**Aufgabe 15** · 2,5 P.

Wofür ist der [[RID]]-Master zuständig?

- [ ] A) Er verwaltet DNS-Zonen
- [ ] B) Er weist den DCs Pools relativer Bezeichner (RIDs) zur Erstellung von SIDs zu
- [ ] C) Er repliziert SYSVOL
- [ ] D) Er authentifiziert Benutzer

> [!success]- Lösung Aufgabe 15
> **B)** Er weist den DCs Pools relativer Bezeichner (RIDs) zur Erstellung von SIDs zu
>
> Der RID-Master vergibt RID-Pools für eindeutige SIDs.

---

**Aufgabe 16** · 2,5 P.

Ein DC wurde ohne Herabstufung ausgeschaltet und die virtuelle Festplatte gelöscht. In der Konsole "Active Directory-Benutzer und -Computer" und in DNS erscheint er weiterhin, und Replikationsfehler treten auf.

**Frage:** Wie bereinigen Sie die Umgebung?

- [ ] A) Den Server neu installieren, dasselbe Namensschema verwenden
- [ ] B) Nur DNS neu starten
- [ ] C) Die Metadaten des DC bereinigen (Objekt in ADUC löschen oder ntdsutil "metadata cleanup") und veraltete DNS-Einträge entfernen
- [ ] D) Alle Benutzerkonten neu anlegen

> [!success]- Lösung Aufgabe 16
> **C)** Die Metadaten des DC bereinigen (Objekt in ADUC löschen oder ntdsutil "metadata cleanup") und veraltete DNS-Einträge entfernen
>
> Verwaiste DC-Objekte und DNS-Einträge müssen manuell bereinigt werden.

---

### Netzwerk – IPv4/IPv6, Routing, DNS, DHCP

**Aufgabe 17** · 2,5 P.

Clients im Firmennetz haben als DNS-Server 8.8.8.8 eingetragen. Interne Servernamen wie fileserver.contoso.local lassen sich nicht auflösen, Internetnamen schon.

**Frage:** Wie beheben Sie das?

- [ ] A) Als DNS-Server den internen DNS-Server (z. B. den DC) eintragen und dort Weiterleitungen für das Internet konfigurieren
- [ ] B) Die Hosts-Datei aller Clients pflegen
- [ ] C) Den DHCP-Server neu installieren
- [ ] D) [[IPv6]] deaktivieren

> [!success]- Lösung Aufgabe 17
> **A)** Als DNS-Server den internen DNS-Server (z. B. den DC) eintragen und dort Weiterleitungen für das Internet konfigurieren
>
> Interne Zonen werden nur vom internen DNS aufgelöst; externe Namen erhalten die Clients über Weiterleitungen.

---

**Aufgabe 18** · 2,5 P.

Welche vier Schritte umfasst die dynamische IP-Vergabe per DHCP (DORA)?

- [ ] A) Discover, Offer, Reply, Ack
- [x] B) Discover, Offer, Request, Acknowledge ✅ 2026-09-25
- [ ] C) Detect, Offer, Renew, Accept
- [ ] D) Discover, Order, Request, Accept

> [!success]- Lösung Aufgabe 18
> **B)** Discover, Offer, Request, Acknowledge
>
> DORA: Discover, Offer, Request, Acknowledge.

---

**Aufgabe 19** · 2,5 P.

Drei Webserver (10.0.0.11 bis 10.0.0.13) sollen unter dem Namen www.contoso.com erreichbar sein und Anfragen möglichst gleichmäßig verteilt bekommen. Eine Lastenausgleichslösung steht nicht zur Verfügung.

**Frage:** Was tun Sie im DNS?

- [ ] A) Nur einen A-Eintrag für den ersten Server anlegen
- [ ] B) Einen MX-Eintrag anlegen
- [ ] C) Drei A-Einträge mit dem Namen www anlegen (Round Robin)
- [ ] D) Einen SRV-Eintrag anlegen

> [!success]- Lösung Aufgabe 19
> **C)** Drei A-Einträge mit dem Namen www anlegen (Round Robin)
>
> DNS Round Robin liefert die Adressen abwechselnd zurück; eine Ausfallerkennung erfolgt dabei nicht.

---

**Aufgabe 20** · 2,5 P.

Welcher DNS-Ressourceneintrag ordnet einem Namen eine [[IPv4]]-Adresse zu?

- [ ] A) A-Eintrag
- [ ] B) MX-Eintrag
- [ ] C) PTR-Eintrag
- [ ] D) SOA-Eintrag

> [!success]- Lösung Aufgabe 20
> **A)** A-Eintrag
>
> Der A-Eintrag (Host) verknüpft einen Namen mit einer IPv4-Adresse.

---

**Aufgabe 21** · 2,5 P.

Im Gästenetz (192.168.50.0/24) ist der DHCP-Bereich (.10 bis .60, Lease-Dauer 8 Tage) durch wechselnde Geräte täglich erschöpft, neue Geräte erhalten keine Adresse.

**Frage:** Was ist sinnvoll?

- [ ] A) Alle Geräte statisch konfigurieren
- [ ] B) Den Bereich vergrößern und die Lease-Dauer für das Gästenetz deutlich verkürzen (z. B. auf wenige Stunden)
- [ ] C) Den Server neu autorisieren
- [ ] D) [[APIPA]] aktivieren

> [!success]- Lösung Aufgabe 21
> **B)** Den Bereich vergrößern und die Lease-Dauer für das Gästenetz deutlich verkürzen (z. B. auf wenige Stunden)
>
> Kurze Leases geben Adressen schneller frei; ein größerer Bereich schafft zusätzliche Kapazität.

---

**Aufgabe 22** · 2,5 P.

Der Server 10.1.0.5 hat als Gateway den Router 10.1.0.1. Im Netz 10.2.0.0/24 liegen weitere Server, die über den Router 10.1.0.254 erreichbar sind. Ein Ping dorthin scheitert.

**Frage:** Wie lösen Sie es?

- [ ] A) Die Subnetzmaske ändern
- [ ] B) Eine statische Route hinzufügen, z. B. New-NetRoute -DestinationPrefix 10.2.0.0/24 -NextHop 10.1.0.254 -InterfaceAlias Ethernet
- [ ] C) Den DNS-Server neu starten
- [ ] D) DHCP-Bereich erweitern

> [!success]- Lösung Aufgabe 22
> **B)** Eine statische Route hinzufügen, z. B. New-NetRoute -DestinationPrefix 10.2.0.0/24 -NextHop 10.1.0.254 -InterfaceAlias Ethernet
>
> Für spezielle Zielnetze wird eine statische Route über den passenden Router benötigt.

---

**Aufgabe 23** · 2,5 P.

Welches Protokoll ersetzt in IPv6 das [[ARP]] von IPv4?

- [ ] A) DHCPv6
- [ ] B) Neighbor Discovery Protocol (NDP, ICMPv6)
- [ ] C) RIPng
- [ ] D) ICMPv4

> [!success]- Lösung Aufgabe 23
> **B)** Neighbor Discovery Protocol (NDP, ICMPv6)
>
> NDP übernimmt Adressauflösung, Router-Erkennung und mehr.

---

**Aufgabe 24** · 2,5 P.

Was ist in einer Active Directory-Umgebung vor dem produktiven Betrieb eines DHCP-Servers erforderlich?

- [ ] A) Ein Neustart des Clients
- [ ] B) Ein statisches Gateway
- [ ] C) Die Autorisierung des DHCP-Servers in AD
- [ ] D) Ein Schreibzugriff auf SYSVOL

> [!success]- Lösung Aufgabe 24
> **C)** Die Autorisierung des DHCP-Servers in AD
>
> Nicht autorisierte DHCP-Server vergeben in AD-Domänen keine Adressen (Schutz vor Rogue-DHCP).

---

**Aufgabe 25** · 2,5 P.

Ein Multihomed-Server ([[LAN]] und [[WAN]]) hat auf beiden Netzwerkkarten ein Standardgateway eingetragen. Die Verbindungen sind unregelmäßig.

**Frage:** Was ist zu tun?

- [ ] A) Beide Standardgateways belassen
- [ ] B) Die WAN-Karte deaktivieren
- [ ] C) Nur ein Standardgateway konfigurieren und für andere Netze statische Routen verwenden
- [ ] D) Die Metrik auf 0 setzen

> [!success]- Lösung Aufgabe 25
> **C)** Nur ein Standardgateway konfigurieren und für andere Netze statische Routen verwenden
>
> Ein Host sollte nur eine Standardroute haben; weitere Ziele werden über statische Routen erreicht.

---

**Aufgabe 26** · 2,5 P.

Ein Windows-11-Client zeigt die IP-Adresse 169.254.33.12 und hat keinen Zugriff auf das Netzwerk. Im Netz gibt es einen DHCP-Server.

**Frage:** Was ist die wahrscheinlichste Ursache?

- [ ] A) Der DNS-Server ist offline
- [ ] B) Der Client hat keine Antwort vom DHCP-Server erhalten (kein erreichbarer DHCP-Server, Bereich erschöpft oder fehlender Relay)
- [ ] C) Das Standardgateway ist falsch eingetragen
- [ ] D) Die Domäne ist gesperrt

> [!success]- Lösung Aufgabe 26
> **B)** Der Client hat keine Antwort vom DHCP-Server erhalten (kein erreichbarer DHCP-Server, Bereich erschöpft oder fehlender Relay)
>
> 169.254.x.x ist APIPA und entsteht, wenn kein DHCP-Server antwortet.

---

### AD CS – Zertifikatdienste

**Aufgabe 27** · 2,5 P.

Mit welchem Cmdlet konfigurieren Sie nach der Rolleninstallation die Zertifizierungsstelle?

- [ ] A) Install-CertificateAuthority
- [ ] B) New-ADCSRole
- [ ] C) Add-CertificationAuthority
- [ ] D) Install-AdcsCertificationAuthority

> [!success]- Lösung Aufgabe 27
> **D)** Install-AdcsCertificationAuthority
>
> Install-AdcsCertificationAuthority führt die Konfiguration (Typ, Schlüssel, Name, Gültigkeit) aus.

---

**Aufgabe 28** · 2,5 P.

Welcher Rollendienst von [[AD CS]] liefert Zertifikatsperrinformationen per [[OCSP]]?

- [ ] A) Zertifizierungsstellen-Webregistrierung
- [ ] B) Registrierungsdienst für Netzwerkgeräte
- [ ] C) Zertifikatregistrierungs-Webdienst
- [ ] D) Online-Responder

> [!success]- Lösung Aufgabe 28
> **D)** Online-Responder
>
> Der Online-Responder beantwortet Statusabfragen einzelner Zertifikate per OCSP.

---

**Aufgabe 29** · 2,5 P.

Die Offline-Root-CA ist eine Standalone-CA. Die untergeordnete Enterprise-CA hat ihr Zertifikat erhalten, aber Clients melden, dass die Zertifikatskette nicht vertrauenswürdig ist.

**Frage:** Was ist zu tun?

- [ ] A) Das Root-CA-Zertifikat und die [[CRL]] in AD veröffentlichen (certutil -dspublish) bzw. per GPO in "Vertrauenswürdige Stammzertifizierungsstellen" verteilen
- [ ] B) Die Clients neu installieren
- [ ] C) Die untergeordnete [[CA]] umbenennen
- [ ] D) DNS neu starten

> [!success]- Lösung Aufgabe 29
> **A)** Das Root-CA-Zertifikat und die CRL in AD veröffentlichen (certutil -dspublish) bzw. per GPO in "Vertrauenswürdige Stammzertifizierungsstellen" verteilen
>
> Standalone-Root-Zertifikate werden nicht automatisch verteilt; Veröffentlichung in AD oder per GPO stellt das Vertrauen her.

---

**Aufgabe 30** · 2,5 P.

Wie wird der Status eines gesperrten Zertifikats üblicherweise veröffentlicht?

- [ ] A) Als DNS-Eintrag
- [ ] B) In einer Zertifikatsperrliste (CRL)
- [ ] C) In der Registry des Clients
- [ ] D) Im SYSVOL-Ordner als Skript

> [!success]- Lösung Aufgabe 30
> **B)** In einer Zertifikatsperrliste (CRL)
>
> Gesperrte Zertifikate stehen in der CRL; alternativ liefert der Online-Responder den Status per OCSP.

---

**Aufgabe 31** · 2,5 P.

Ein Notebook mit einem Computerzertifikat für die [[VPN]]-Authentifizierung wurde gestohlen.

**Frage:** Wie reagieren Sie?

- [ ] A) Das Notebook aus der Domäne entfernen und nichts weiter tun
- [ ] B) Das Zertifikat unter "Ausgestellte Zertifikate" sperren (z. B. Grund: Schlüsselkompromittierung) und eine neue CRL veröffentlichen
- [ ] C) Die Vorlage löschen
- [ ] D) Die Root CA neu installieren

> [!success]- Lösung Aufgabe 31
> **B)** Das Zertifikat unter "Ausgestellte Zertifikate" sperren (z. B. Grund: Schlüsselkompromittierung) und eine neue CRL veröffentlichen
>
> Gesperrte Zertifikate erscheinen in der nächsten CRL; die CRL sollte sofort neu veröffentlicht werden.

---

**Aufgabe 32** · 2,5 P.

Welchen Vorteil bietet ein Online-Responder gegenüber einer CRL?

- [ ] A) Er beantwortet Statusabfragen für einzelne Zertifikate, ohne dass große Sperrlisten geladen werden müssen
- [ ] B) Er stellt selbst Zertifikate aus
- [ ] C) Er ersetzt die Root CA
- [ ] D) Er verschlüsselt die Datenbank

> [!success]- Lösung Aufgabe 32
> **A)** Er beantwortet Statusabfragen für einzelne Zertifikate, ohne dass große Sperrlisten geladen werden müssen
>
> OCSP reduziert Datenmengen und liefert aktuellere Statusinformationen.

---

### AD FS & Webanwendungsproxy

**Aufgabe 33** · 2,5 P.

Welche Voraussetzung muss vor dem Einrichten einer AD FS-Farm erfüllt sein?

- [ ] A) Ein Exchange-Server
- [ ] B) Ein Domänencontroller mit Windows Server 2003
- [ ] C) Ein [[TLS]]/[[SSL]]-Zertifikat mit dem Namen des Verbunddienstes (z. B. sts.contoso.com) und ein passender DNS-Eintrag
- [ ] D) Ein DHCP-Bereich für den Verbunddienst

> [!success]- Lösung Aufgabe 33
> **C)** Ein TLS/SSL-Zertifikat mit dem Namen des Verbunddienstes (z. B. sts.contoso.com) und ein passender DNS-Eintrag
>
> Für den Verbunddienstnamen werden ein vertrauenswürdiges Zertifikat und DNS benötigt; empfohlen ist zudem ein gruppenverwaltetes Dienstkonto (gMSA).

---

**Aufgabe 34** · 2,5 P.

Mit welchem PowerShell-Befehl installieren Sie die AD FS-Rolle?

- [ ] A) Install-Module [[ADFS]]
- [ ] B) Install-WindowsFeature ADFS-Federation -IncludeManagementTools
- [ ] C) Add-WindowsCapability -Name ADFS
- [ ] D) Enable-ADFSRole

> [!success]- Lösung Aufgabe 34
> **B)** Install-WindowsFeature ADFS-Federation -IncludeManagementTools
>
> Die Rolle wird per Install-WindowsFeature ADFS-Federation installiert; danach wird der Verbunddienst konfiguriert (Install-AdfsFarm).

---

**Aufgabe 35** · 2,5 P.

Welche Konfigurationsdatenbank verwendet AD FS standardmäßig?

- [ ] A) Die AD-Datenbank NTDS.dit
- [ ] B) Die Registry
- [ ] C) Die Windows Internal Database (WID); für große Farmen optional [[SQL]] Server
- [ ] D) Eine Textdatei im SYSVOL

> [!success]- Lösung Aufgabe 35
> **C)** Die Windows Internal Database (WID); für große Farmen optional SQL Server
>
> Standard ist die WID, die zwischen den Farmknoten repliziert wird; SQL Server ist für große Umgebungen möglich.

---

## Teil B – Eingabeaufgaben (5 Aufgaben)

**Aufgabe 36** · 2,5 P. · *Netzwerk – IPv4/IPv6, Routing, DNS, DHCP*

Welche Subnetzmaske entspricht der Präfixlänge /27?
(Punktdezimal eingeben)

Antwort: 

> [!success]- Lösung Aufgabe 36
> **255.255.255.224**
>
> /27 = 27 Netzbits, letztes Oktett 11100000 = 224.

---

**Aufgabe 37** · 2,5 P. · *AD DS – Domänendienste*

Wie viele [[FSMO]]-Rollen (Betriebsmaster) gibt es insgesamt?
(Zahl eingeben)

Antwort: 

> [!success]- Lösung Aufgabe 37
> **5**
>
> Fünf Rollen: Schemamaster, Domänennamenmaster, PDC-Emulator, RID-Master, Infrastrukturmaster.

---

**Aufgabe 38** · 2,5 P. · *AD DS – Domänendienste*

Wie viele Minuten beträgt die Standard-Zeittoleranz, ab der [[Kerberos]]-Authentifizierung fehlschlägt?
(Zahl eingeben)

Antwort: 

> [!success]- Lösung Aufgabe 38
> **5 Minuten**
>
> Standardmäßig 5 Minuten Abweichung; die Zeit wird vom PDC-Emulator abgeleitet.

---

**Aufgabe 39** · 2,5 P. · *AD DS – Domänendienste*

Welcher Port wird standardmäßig für unverschlüsseltes [[LDAP]] verwendet?
(Zahl eingeben)

Antwort: 

> [!success]- Lösung Aufgabe 39
> **389**
>
> LDAP nutzt Port 389, LDAPS Port 636, Kerberos Port 88.

---

**Aufgabe 40** · 2,5 P. · *AD DS – Domänendienste*

Mit welchem Cmdlet erstellen Sie eine neue Active Directory-Gesamtstruktur?
(Cmdlet-Namen eingeben)

Antwort: 

> [!success]- Lösung Aufgabe 40
> **Install-ADDSForest**
>
> Install-ADDSForest erstellt Gesamtstruktur und erste Domäne.

---

## Auswertung

> [!check]- Lösungsschlüssel
> | Nr. | Lösung | Thema |
> |---|---|---|
> | 1 | A | AD DS |
> | 2 | B | AD DS |
> | 3 | D | AD DS |
> | 4 | B | AD DS |
> | 5 | B | AD DS |
> | 6 | A | AD DS |
> | 7 | D | AD DS |
> | 8 | A | AD DS |
> | 9 | C | AD DS |
> | 10 | B | AD DS |
> | 11 | B | AD DS |
> | 12 | D | AD DS |
> | 13 | A | AD DS |
> | 14 | A | AD DS |
> | 15 | B | AD DS |
> | 16 | C | AD DS |
> | 17 | A | Netzwerk |
> | 18 | B | Netzwerk |
> | 19 | C | Netzwerk |
> | 20 | A | Netzwerk |
> | 21 | B | Netzwerk |
> | 22 | B | Netzwerk |
> | 23 | B | Netzwerk |
> | 24 | C | Netzwerk |
> | 25 | C | Netzwerk |
> | 26 | B | Netzwerk |
> | 27 | D | AD CS |
> | 28 | D | AD CS |
> | 29 | A | AD CS |
> | 30 | B | AD CS |
> | 31 | B | AD CS |
> | 32 | A | AD CS |
> | 33 | C | AD FS & Webanwendungsproxy |
> | 34 | B | AD FS & Webanwendungsproxy |
> | 35 | C | AD FS & Webanwendungsproxy |
> | 36 | 255.255.255.224 | Netzwerk |
> | 37 | 5 | AD DS |
> | 38 | 5 Minuten | AD DS |
> | 39 | 389 | AD DS |
> | 40 | Install-ADDSForest | AD DS |

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
