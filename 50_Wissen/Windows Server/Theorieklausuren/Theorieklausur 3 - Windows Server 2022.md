---
title: "Theorieklausur 3 - Windows Server 2022"
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
# Theorieklausur 3 - Windows Server 2022

Zurück zur Übersicht: [[00 Uebersicht Theorieklausuren]]

> [!info] Hinweise
> - Bearbeitungszeit: **90 Minuten**, Hilfsmittel: keine
> - 40 Aufgaben je **2,5 Punkte** = 100 Punkte
> - Teil A: Multiple Choice, genau eine Antwort richtig (Kästchen anhaken)
> - Teil B: Eingabeaufgaben, Antwort hinter "Antwort:" eintragen
> - Lösungen sind eingeklappt. Erst nach der Bearbeitung aufklappen.

## Teil A - Multiple Choice (35 Aufgaben)

### AD DS - Domänendienste

**Aufgabe 1** - 2,5 P.

Welche Voraussetzung sollte vor der Heraufstufung eines Servers zum Domänencontroller erfüllt sein?

- [ ] A) Der Server erhält seine [[IP]]-Adresse per [[DHCP]]
- [ ] B) Der Server hat eine statische IP-Adresse und einen eindeutigen Computernamen
- [ ] C) Auf dem Server ist Exchange installiert
- [ ] D) Der Server ist Mitglied einer Arbeitsgruppe mit dem Namen der künftigen Domäne

> [!success]- Lösung Aufgabe 1
> **B)** Der Server hat eine statische IP-Adresse und einen eindeutigen Computernamen
>
> Ein [[DC]] braucht eine statische IP-Adresse und einen festen Computernamen.

---

**Aufgabe 2** - 2,5 P.

Worin unterscheidet sich eine Organisationseinheit ([[OU]]) von einem Standardcontainer wie "Users"?

- [ ] A) Auf eine OU können Gruppenrichtlinien verknüpft und Verwaltungsaufgaben delegiert werden
- [ ] B) OUs können nur Computerkonten enthalten
- [ ] C) Standardcontainer sind schneller
- [ ] D) Es gibt keinen Unterschied

> [!success]- Lösung Aufgabe 2
> **A)** Auf eine OU können Gruppenrichtlinien verknüpft und Verwaltungsaufgaben delegiert werden
>
> Nur auf OUs lassen sich GPOs verknüpfen und Rechte delegieren.

---

**Aufgabe 3** - 2,5 P.

Die Abteilung Forschung möchte eigene Administratoren, verwaltet aber keine anderen Kennwortrichtlinien und benötigt keine eigene Sicherheitsgrenze. Der IT-Leiter erwägt eine neue Domäne research.contoso.local.

**Frage:** Was empfehlen Sie?

- [ ] A) Immer eine neue Domäne, da eine OU keine Verwaltungsrechte delegieren kann
- [ ] B) Eine neue Gesamtstruktur für Forschung
- [ ] C) Eine zweite Domäne mit einem zusätzlichen Globalen Katalog
- [ ] D) Eine OU "Forschung" mit delegierter Verwaltung, da keine Domänengrenze erforderlich ist

> [!success]- Lösung Aufgabe 3
> **D)** Eine OU "Forschung" mit delegierter Verwaltung, da keine Domänengrenze erforderlich ist
>
> Eine Domäne ist nur bei abweichenden Domänenrichtlinien oder Replikationsanforderungen nötig; OU mit Delegierung ist einfacher.

---

**Aufgabe 4** - 2,5 P.

Mit welchem Cmdlet übertragen Sie [[FSMO]]-Rollen kontrolliert auf einen anderen DC?

- [ ] A) Move-ADDirectoryServerOperationMasterRole
- [ ] B) Set-ADFSMO
- [ ] C) Transfer-ADRole
- [ ] D) Copy-ADDomainController

> [!success]- Lösung Aufgabe 4
> **A)** Move-ADDirectoryServerOperationMasterRole
>
> Move-ADDirectoryServerOperationMasterRole überträgt Rollen geordnet.

---

**Aufgabe 5** - 2,5 P.

Mit welchem Befehl zeigen Sie an, welche DCs die FSMO-Rollen halten?

- [ ] A) netdom query fsmo
- [ ] B) ipconfig /fsmo
- [ ] C) nslookup fsmo
- [ ] D) gpresult /fsmo

> [!success]- Lösung Aufgabe 5
> **A)** netdom query fsmo
>
> netdom query fsmo (alternativ Get-ADDomain / Get-ADForest).

---

**Aufgabe 6** - 2,5 P.

Die Personalabteilung liefert eine CSV-Datei mit 500 neuen Mitarbeitern (Vorname, Nachname, Abteilung). Diese sollen als Benutzerkonten in [[AD]] angelegt werden.

**Frage:** Wie automatisieren Sie das?

- [ ] A) Jedes Konto manuell im Snap-In anlegen
- [ ] B) Die CSV in [[SYSVOL]] kopieren
- [ ] C) Import-Csv mit einer Schleife und New-ADUser verwenden
- [ ] D) Die Konten über die Registry importieren

> [!success]- Lösung Aufgabe 6
> **C)** Import-Csv mit einer Schleife und New-ADUser verwenden
>
> Import-Csv liest die Datei, ForEach-Object ruft New-ADUser auf.

---

**Aufgabe 7** - 2,5 P.

Welche [[DNS]]-Zonenart wird für AD empfohlen?

- [ ] A) Primäre Standardzone
- [ ] B) Sekundäre Zone
- [ ] C) Active Directory-integrierte Zone
- [ ] D) Stubzone

> [!success]- Lösung Aufgabe 7
> **C)** Active Directory-integrierte Zone
>
> AD-integrierte Zonen werden per AD repliziert und erlauben sichere dynamische Updates.

---

**Aufgabe 8** - 2,5 P.

Was gilt für den Active Directory-Papierkorb?

- [ ] A) Er ist standardmäßig aktiv und lässt sich deaktivieren
- [ ] B) Er muss aktiviert werden (Enable-ADOptionalFeature) und kann danach nicht mehr deaktiviert werden
- [ ] C) Er speichert nur Computerkonten
- [ ] D) Er steht nur unter Windows Server 2003 zur Verfügung

> [!success]- Lösung Aufgabe 8
> **B)** Er muss aktiviert werden (Enable-ADOptionalFeature) und kann danach nicht mehr deaktiviert werden
>
> Aktivierung mit Enable-ADOptionalFeature; danach nicht mehr rückgängig zu machen.

---

**Aufgabe 9** - 2,5 P.

Mit welchem Cmdlet heben Sie die Domänenfunktionsebene an?

- [ ] A) Set-ADDomainMode
- [ ] B) Set-ADFunctionLevel
- [ ] C) Update-ADDomain
- [ ] D) Raise-ADDomain

> [!success]- Lösung Aufgabe 9
> **A)** Set-ADDomainMode
>
> Set-ADDomainMode (bzw. Set-ADForestMode für die Gesamtstruktur).

---

**Aufgabe 10** - 2,5 P.

Welches Snap-In dient der Verwaltung von Benutzern, Gruppen und Computern (dsa.msc)?

- [ ] A) Active Directory-Standorte und -Dienste
- [ ] B) Active Directory-Benutzer und -Computer
- [ ] C) DNS-Manager
- [ ] D) Geräte-Manager

> [!success]- Lösung Aufgabe 10
> **B)** Active Directory-Benutzer und -Computer
>
> dsa.msc: Active Directory-Benutzer und -Computer.

---

**Aufgabe 11** - 2,5 P.

Domäne: contoso.local. Die Benutzer sollen sich mit ihrer E-Mail-Adresse (z. B. anna@contoso.com) als [[UPN]] anmelden.

**Frage:** Was konfigurieren Sie dafür?

- [ ] A) Die Domäne in contoso.com umbenennen
- [ ] B) Ein neues DNS-Forwarding einrichten
- [ ] C) Ein alternatives UPN-Suffix contoso.com in "Active Directory-Domänen und -Vertrauensstellungen" hinzufügen und den Benutzern zuweisen
- [ ] D) Den Globalen Katalog deaktivieren

> [!success]- Lösung Aufgabe 11
> **C)** Ein alternatives UPN-Suffix contoso.com in "Active Directory-Domänen und -Vertrauensstellungen" hinzufügen und den Benutzern zuweisen
>
> Zusätzliche UPN-Suffixe werden gesamtstrukturweit in domain.msc angelegt.

---

**Aufgabe 12** - 2,5 P.

Wie schützen Sie eine OU vor versehentlichem Löschen?

- [ ] A) Durch die Option "Vor zufälligem Löschen schützen"
- [ ] B) Durch Umbenennen der OU
- [ ] C) Durch Verschieben in den Container Users
- [ ] D) Durch Deaktivieren der OU

> [!success]- Lösung Aufgabe 12
> **A)** Durch die Option "Vor zufälligem Löschen schützen"
>
> Der Schutz vor versehentlichem Löschen verhindert das Löschen und Verschieben ohne Aufhebung.

---

**Aufgabe 13** - 2,5 P.

In der Domäne contoso.local gibt es nur den DC01. Der Geschäftsführer fordert Ausfallsicherheit für die Anmeldung. SRV02 ist Mitglied der Domäne.

**Frage:** Wie gehen Sie vor?

- [ ] A) SRV02 aus der Domäne entfernen und eine neue Gesamtstruktur anlegen
- [ ] B) Nur die DNS-Rolle auf SRV02 installieren
- [ ] C) [[AD DS]] auf SRV02 installieren und mit Install-ADDSDomainController zum zusätzlichen DC heraufstufen
- [ ] D) Die Datei NTDS.dit manuell von DC01 nach SRV02 kopieren

> [!success]- Lösung Aufgabe 13
> **C)** AD DS auf SRV02 installieren und mit Install-ADDSDomainController zum zusätzlichen DC heraufstufen
>
> Ein zusätzlicher DC wird über Rolleninstallation und Install-ADDSDomainController hinzugefügt; die Datenbank wird per Replikation übertragen.

---

**Aufgabe 14** - 2,5 P.

Welche Aussage zur Domäne trifft zu?

- [ ] A) Sie ist die Grenze für die Replikation der Domänenpartition
- [ ] B) Sie ist die Grenze des Schemas
- [ ] C) Sie enthält immer genau einen DC
- [ ] D) Sie ist identisch mit einem IP-Subnetz

> [!success]- Lösung Aufgabe 14
> **A)** Sie ist die Grenze für die Replikation der Domänenpartition
>
> Die Domänenpartition wird nur innerhalb der Domäne repliziert.

---

**Aufgabe 15** - 2,5 P.

Was ist die Aufgabe des Infrastrukturmasters?

- [ ] A) Er aktualisiert Verweise auf Objekte aus anderen Domänen (Gruppenmitgliedschaften)
- [ ] B) Er erstellt Gruppenrichtlinien
- [ ] C) Er verwaltet den Papierkorb
- [ ] D) Er ist für [[Kerberos]]-Tickets zuständig

> [!success]- Lösung Aufgabe 15
> **A)** Er aktualisiert Verweise auf Objekte aus anderen Domänen (Gruppenmitgliedschaften)
>
> Er pflegt Verweise auf Objekte anderer Domänen; er sollte nicht auf einem GC liegen, außer alle DCs sind GC.

---

**Aufgabe 16** - 2,5 P.

Welche Aufgabe hat der Globale Katalog (GC)?

- [ ] A) Er speichert Kennwörter im Klartext
- [ ] B) Er enthält eine Teilmenge der Attribute aller Objekte der Gesamtstruktur für gesamtstrukturweite Suchen und die Anmeldung
- [ ] C) Er verteilt IP-Adressen
- [ ] D) Er speichert nur Gruppenrichtlinien

> [!success]- Lösung Aufgabe 16
> **B)** Er enthält eine Teilmenge der Attribute aller Objekte der Gesamtstruktur für gesamtstrukturweite Suchen und die Anmeldung
>
> Der GC enthält eine Attribut-Teilmenge aller Objekte und wertet z. B. universelle Gruppen bei der Anmeldung aus.

---

### Netzwerk - IPv4/IPv6, Routing, DNS, DHCP

**Aufgabe 17** - 2,5 P.

Ein Server (10.5.0.20/24) erreicht andere Server im selben Subnetz, aber weder das Internet noch andere Subnetze. route print zeigt keine Route zu 0.0.0.0.

**Frage:** Was fehlt?

- [ ] A) Ein Standardgateway bzw. eine Standardroute 0.0.0.0/0 zum Router
- [ ] B) Ein DHCP-Bereich
- [ ] C) Eine Reverse-Lookupzone
- [ ] D) Ein Serverzertifikat

> [!success]- Lösung Aufgabe 17
> **A)** Ein Standardgateway bzw. eine Standardroute 0.0.0.0/0 zum Router
>
> Ohne Standardroute weiß der Host nicht, wohin Pakete für Ziele außerhalb des Subnetzes gesendet werden sollen.

---

**Aufgabe 18** - 2,5 P.

Der Webserver web01 (A-Eintrag) soll zusätzlich unter dem Namen intranet.contoso.local erreichbar sein, ohne eine zweite IP-Adresse zu verwenden.

**Frage:** Was legen Sie in DNS an?

- [ ] A) Einen zweiten A-Eintrag mit anderer IP
- [ ] B) Einen CNAME-Eintrag intranet, der auf web01.contoso.local verweist
- [ ] C) Einen MX-Eintrag
- [ ] D) Einen PTR-Eintrag intranet

> [!success]- Lösung Aufgabe 18
> **B)** Einen CNAME-Eintrag intranet, der auf web01.contoso.local verweist
>
> Ein CNAME ist ein Alias auf einen bestehenden Namen.

---

**Aufgabe 19** - 2,5 P.

Der einzige DHCP-Server fällt aus, und Clients erhalten keine Adressen mehr. Sie sollen die Verfügbarkeit erhöhen, ohne die Konfiguration zweimal manuell zu pflegen.

**Frage:** Was implementieren Sie?

- [ ] A) Einen zweiten, unabhängigen DHCP-Server mit identischen Bereichen ohne Verbindung
- [ ] B) Statische IP-Adressen für alle Clients
- [ ] C) DHCP-Failover (Hot-Standby oder Lastenausgleich) zwischen zwei Servern
- [ ] D) Eine [[APIPA]]-Konfiguration

> [!success]- Lösung Aufgabe 19
> **C)** DHCP-Failover (Hot-Standby oder Lastenausgleich) zwischen zwei Servern
>
> DHCP-Failover repliziert Bereiche und Leases zwischen zwei Servern und vermeidet Adresskonflikte.

---

**Aufgabe 20** - 2,5 P.

Ihre Firma arbeitet mit dem Partner fabrikam.com zusammen. Anfragen für partner.fabrikam.com sollen direkt an dessen DNS-Server 203.0.113.53 gehen; alle anderen Anfragen wie bisher.

**Frage:** Welche Funktion richten Sie ein?

- [ ] A) Eine sekundäre Zone für das Internet
- [ ] B) Eine bedingte Weiterleitung (Conditional Forwarder) für fabrikam.com an 203.0.113.53
- [ ] C) Einen zusätzlichen DHCP-Bereich
- [ ] D) Ein neues Standardgateway

> [!success]- Lösung Aufgabe 20
> **B)** Eine bedingte Weiterleitung (Conditional Forwarder) für fabrikam.com an 203.0.113.53
>
> Bedingte Weiterleitungen leiten Anfragen für bestimmte Domänen gezielt weiter.

---

**Aufgabe 21** - 2,5 P.

Wofür wird ein PTR-Eintrag verwendet?

- [ ] A) Zur Vergabe von IP-Adressen
- [ ] B) Zur Auflösung einer IP-Adresse in einen Namen (Reverse-Lookup)
- [ ] C) Zur Zuordnung eines Aliasnamens
- [ ] D) Zur Definition des Mailservers

> [!success]- Lösung Aufgabe 21
> **B)** Zur Auflösung einer IP-Adresse in einen Namen (Reverse-Lookup)
>
> PTR-Einträge liegen in Reverse-Lookupzonen (in-addr.arpa, ip6.arpa).

---

**Aufgabe 22** - 2,5 P.

Ein neu installierter DHCP-Server in einer AD-Domäne hat einen aktivierten Bereich, vergibt aber keine Adressen. Im DHCP-Manager erscheint ein roter Pfeil am Servernamen.

**Frage:** Was ist die Ursache und Lösung?

- [ ] A) Die Subnetzmaske ist falsch
- [ ] B) Der DNS-Server fehlt
- [ ] C) Der Bereich ist zu groß
- [ ] D) Der DHCP-Server ist in Active Directory nicht autorisiert; Autorisierung durchführen (z. B. Add-DhcpServerInDC)

> [!success]- Lösung Aufgabe 22
> **D)** Der DHCP-Server ist in Active Directory nicht autorisiert; Autorisierung durchführen (z. B. Add-DhcpServerInDC)
>
> In AD-Umgebungen müssen DHCP-Server autorisiert werden; der rote Pfeil zeigt einen nicht autorisierten Server.

---

**Aufgabe 23** - 2,5 P.

Was kennzeichnet eine sekundäre DNS-Zone?

- [ ] A) Eine schreibgeschützte Kopie einer Primärzone, die per Zonenübertragung aktualisiert wird
- [ ] B) Eine beschreibbare Zone auf jedem DC
- [ ] C) Eine Zone nur für Weiterleitungen
- [ ] D) Eine Zone für DHCP-Daten

> [!success]- Lösung Aufgabe 23
> **A)** Eine schreibgeschützte Kopie einer Primärzone, die per Zonenübertragung aktualisiert wird
>
> Sekundärzonen erhalten ihre Daten per Zonenübertragung vom Primärserver.

---

**Aufgabe 24** - 2,5 P.

Welche der folgenden [[IPv4]]-Adressen liegt in einem privaten Adressbereich (RFC 1918)?

- [ ] A) 172.32.1.1
- [ ] B) 172.20.5.4
- [ ] C) 192.169.1.1
- [ ] D) 11.0.0.1

> [!success]- Lösung Aufgabe 24
> **B)** 172.20.5.4
>
> Privat sind 10.0.0.0/8, 172.16.0.0/12 (172.16-172.31) und 192.168.0.0/16.

---

**Aufgabe 25** - 2,5 P.

Die Domäne contoso.com wird öffentlich von einem Provider aufgelöst. Intern soll intranet.contoso.com auf 10.0.0.5 zeigen, extern auf die öffentliche Adresse.

**Frage:** Welche Lösung setzen Sie um?

- [ ] A) Split-DNS: Auf den internen DNS-Servern eine Zone contoso.com mit den internen Einträgen führen; die externe Zone bleibt beim Provider
- [ ] B) Auf jedem Client die Hosts-Datei pflegen
- [ ] C) Nur einen CNAME anlegen
- [ ] D) Einen DHCP-Bereich mit Domänenoption anlegen

> [!success]- Lösung Aufgabe 25
> **A)** Split-DNS: Auf den internen DNS-Servern eine Zone contoso.com mit den internen Einträgen führen; die externe Zone bleibt beim Provider
>
> Bei Split-DNS liefern interne und externe DNS-Server für denselben Namen unterschiedliche Antworten.

---

**Aufgabe 26** - 2,5 P.

Zwei PCs hängen am selben Switch: PC1 hat 192.168.1.10/24, PC2 hat 192.168.2.20/24. Ein Ping von PC1 zu PC2 schlägt fehl.

**Frage:** Warum?

- [ ] A) Der Switch blockiert [[ICMP]]
- [ ] B) Die [[MAC]]-Adressen sind identisch
- [ ] C) Die Geräte liegen in unterschiedlichen IP-Subnetzen; ohne Router oder Layer-3-Switch besteht keine Verbindung
- [ ] D) DHCP ist deaktiviert

> [!success]- Lösung Aufgabe 26
> **C)** Die Geräte liegen in unterschiedlichen IP-Subnetzen; ohne Router oder Layer-3-Switch besteht keine Verbindung
>
> Unterschiedliche Subnetze kommunizieren nur über einen Router.

---

### AD CS - Zertifikatdienste

**Aufgabe 27** - 2,5 P.

Wie wird die Datenbank einer Zertifizierungsstelle gespeichert?

- [ ] A) Als Textdatei im Ordner SYSVOL
- [ ] B) Als ESE-Datenbank (.edb) im Ordner CertLog
- [ ] C) In der Datei NTDS.dit
- [ ] D) In der Registry

> [!success]- Lösung Aufgabe 27
> **B)** Als ESE-Datenbank (.edb) im Ordner CertLog
>
> Die [[CA]]-Datenbank ist eine ESE-Datenbank (Standard: C:\Windows\System32\CertLog).

---

**Aufgabe 28** - 2,5 P.

Welche Berechtigungen benötigt eine Gruppe auf einer Vorlage für die automatische Registrierung?

- [ ] A) Nur Lesen
- [ ] B) Vollzugriff
- [ ] C) Lesen, Registrieren und Automatisch registrieren
- [ ] D) Schreiben und Löschen

> [!success]- Lösung Aufgabe 28
> **C)** Lesen, Registrieren und Automatisch registrieren
>
> Die Rechte Lesen, Registrieren und Automatisch registrieren sind notwendig.

---

**Aufgabe 29** - 2,5 P.

Wie gehen Sie vor, wenn Sie eine Standardzertifikatvorlage anpassen möchten?

- [ ] A) Die Standardvorlage direkt bearbeiten
- [ ] B) Die Vorlage löschen und neu erstellen
- [ ] C) Die CA neu installieren
- [ ] D) Die Vorlage duplizieren und die Kopie anpassen

> [!success]- Lösung Aufgabe 29
> **D)** Die Vorlage duplizieren und die Kopie anpassen
>
> Standardvorlagen sollten nicht verändert werden; man arbeitet mit Duplikaten.

---

**Aufgabe 30** - 2,5 P.

Clients melden beim Aufbau von [[HTTPS]]-Verbindungen: "Der Sperrstatus des Zertifikats konnte nicht überprüft werden." Die untergeordnete CA läuft; die Offline-Root-CA wurde zuletzt vor sieben Monaten eingeschaltet.

**Frage:** Was ist die wahrscheinlichste Ursache?

- [ ] A) Die Vorlage ist veraltet
- [ ] B) Der DHCP-Server ist ausgefallen
- [ ] C) Die [[CRL]] der Offline-Root-CA ist abgelaufen; sie muss neu veröffentlicht und im [[CDP]]-Ort bereitgestellt werden
- [ ] D) Das Webserver-Zertifikat wurde nicht signiert

> [!success]- Lösung Aufgabe 30
> **C)** Die CRL der Offline-Root-CA ist abgelaufen; sie muss neu veröffentlicht und im CDP-Ort bereitgestellt werden
>
> Offline-CAs haben lange CRL-Laufzeiten; abgelaufene CRLs verhindern die Sperrprüfung.

---

**Aufgabe 31** - 2,5 P.

Was bedeuten die Erweiterungen [[AIA]] und CDP in einem Zertifikat?

- [ ] A) AIA nennt den Speicherort der CRL, CDP den Ort des Ausstellerzertifikats
- [ ] B) Beide bezeichnen Registrierungsserver
- [ ] C) AIA verweist auf das Zertifikat der ausstellenden CA, CDP auf die Sperrliste (CRL)
- [ ] D) Beide sind DNS-Einträge

> [!success]- Lösung Aufgabe 31
> **C)** AIA verweist auf das Zertifikat der ausstellenden CA, CDP auf die Sperrliste (CRL)
>
> AIA (Authority Information Access) und CDP (CRL Distribution Point) ermöglichen Kettenbildung und Sperrprüfung.

---

**Aufgabe 32** - 2,5 P.

Mitarbeiter sollen E-Mails digital signieren. Die Benutzerzertifikate sollen automatisch aus AD-Konten ausgestellt werden, ohne dass Benutzer eine Anforderung stellen.

**Frage:** Welche Lösung passt?

- [ ] A) Manuelle Anforderung über die Webregistrierung
- [ ] B) Eine Benutzerzertifikatvorlage mit Autoregistrierung für Domänenbenutzer und eine [[GPO]] zur automatischen Registrierung in der Benutzerkonfiguration
- [ ] C) Zertifikate auf [[USB]]-Sticks verteilen
- [ ] D) Ein DHCP-Bereich mit Zertifikaten

> [!success]- Lösung Aufgabe 32
> **B)** Eine Benutzerzertifikatvorlage mit Autoregistrierung für Domänenbenutzer und eine GPO zur automatischen Registrierung in der Benutzerkonfiguration
>
> Benutzerzertifikate werden per Vorlage und GPO (Benutzerkonfiguration) automatisch registriert.

---

### AD FS & Webanwendungsproxy

**Aufgabe 33** - 2,5 P.

Was sind Ansprüche (Claims) in AD FS?

- [ ] A) IP-Adressen der Clients
- [ ] B) Berechtigungen auf Dateiservern
- [ ] C) Kennwörter der Benutzer
- [ ] D) Aussagen über einen Benutzer (z. B. Name, E-Mail, Gruppenmitgliedschaft), die im Sicherheitstoken enthalten sind und von Anwendungen ausgewertet werden

> [!success]- Lösung Aufgabe 33
> **D)** Aussagen über einen Benutzer (z. B. Name, E-Mail, Gruppenmitgliedschaft), die im Sicherheitstoken enthalten sind und von Anwendungen ausgewertet werden
>
> Claims sind Attribute, die der Anspruchsanbieter in das Token schreibt.

---

**Aufgabe 34** - 2,5 P.

Welche Protokolle unterstützt AD FS unter Windows Server 2022 unter anderem?

- [ ] A) Nur [[NTLM]]
- [ ] B) SAML 2.0, WS-Federation, OAuth 2.0 und OpenID Connect
- [ ] C) Nur Kerberos
- [ ] D) Nur [[RADIUS]]

> [!success]- Lösung Aufgabe 34
> **B)** SAML 2.0, WS-Federation, OAuth 2.0 und OpenID Connect
>
> AD FS unterstützt SAML, WS-Federation sowie OAuth 2.0 und OpenID Connect für moderne Anwendungen.

---

**Aufgabe 35** - 2,5 P.

Was konfigurieren Sie in AD FS, damit einer Anwendung Tokens ausgestellt werden?

- [ ] A) Eine Vertrauensstellung der vertrauenden Seite (Relying Party Trust) für die Anwendung
- [ ] B) Eine DHCP-Reservierung
- [ ] C) Eine DNS-Weiterleitung
- [ ] D) Eine Organisationseinheit

> [!success]- Lösung Aufgabe 35
> **A)** Eine Vertrauensstellung der vertrauenden Seite (Relying Party Trust) für die Anwendung
>
> Die Relying Party Trust beschreibt die Anwendung, ihre Endpunkte und die Anspruchsregeln.

---

## Teil B - Eingabeaufgaben (5 Aufgaben)

**Aufgabe 36** - 2,5 P. - *Netzwerk - IPv4/[[IPv6]], Routing, DNS, DHCP*

Wie viele nutzbare Hostadressen bietet ein IPv4-Subnetz mit der Präfixlänge /26?
(Zahl eingeben)

Antwort: 

> [!success]- Lösung Aufgabe 36
> **62**
>
> 2^6 = 64 Adressen, abzüglich Netz- und Broadcastadresse = 62 Hosts.

---

**Aufgabe 37** - 2,5 P. - *Netzwerk - IPv4/IPv6, Routing, DNS, DHCP*

Wie lautet die korrekte Kurzschreibweise von 2001:0db8:0000:0000:0000:0000:0000:0001?
(Adresse eingeben)

Antwort: 

> [!success]- Lösung Aufgabe 37
> **2001:db8::1**
>
> Führende Nullen entfallen, eine Folge von Nullgruppen wird einmal durch :: ersetzt.

---

**Aufgabe 38** - 2,5 P. - *AD DS - Domänendienste*

Welcher Port wird für unverschlüsselte Abfragen am Globalen Katalog verwendet?
(Zahl eingeben)

Antwort: 

> [!success]- Lösung Aufgabe 38
> **3268**
>
> Globaler Katalog: 3268 (unverschlüsselt), 3269 ([[SSL]]).

---

**Aufgabe 39** - 2,5 P. - *Netzwerk - IPv4/IPv6, Routing, DNS, DHCP*

Welcher Adressbereich (Netz/Präfix) wird bei einem Windows-Client verwendet, wenn kein DHCP-Server erreichbar ist (APIPA)?
(Eingabe, z. B. 10.0.0.0/8)

Antwort: 

> [!success]- Lösung Aufgabe 39
> **169.254.0.0/16**
>
> APIPA vergibt Adressen aus 169.254.0.0/16 (Link-Local).

---

**Aufgabe 40** - 2,5 P. - *Netzwerk - IPv4/IPv6, Routing, DNS, DHCP*

Welchen Standardport nutzt DNS für Abfragen?
(Zahl eingeben)

Antwort: 

> [!success]- Lösung Aufgabe 40
> **53**
>
> DNS nutzt Port 53 ([[UDP]] für Abfragen, [[TCP]] für Zonenübertragungen und große Antworten).

---

## Auswertung

> [!check]- Lösungsschlüssel
> | Nr. | Lösung | Thema |
> |---|---|---|
> | 1 | B | AD DS |
> | 2 | A | AD DS |
> | 3 | D | AD DS |
> | 4 | A | AD DS |
> | 5 | A | AD DS |
> | 6 | C | AD DS |
> | 7 | C | AD DS |
> | 8 | B | AD DS |
> | 9 | A | AD DS |
> | 10 | B | AD DS |
> | 11 | C | AD DS |
> | 12 | A | AD DS |
> | 13 | C | AD DS |
> | 14 | A | AD DS |
> | 15 | A | AD DS |
> | 16 | B | AD DS |
> | 17 | A | Netzwerk |
> | 18 | B | Netzwerk |
> | 19 | C | Netzwerk |
> | 20 | B | Netzwerk |
> | 21 | B | Netzwerk |
> | 22 | D | Netzwerk |
> | 23 | A | Netzwerk |
> | 24 | B | Netzwerk |
> | 25 | A | Netzwerk |
> | 26 | C | Netzwerk |
> | 27 | B | [[AD CS]] |
> | 28 | C | AD CS |
> | 29 | D | AD CS |
> | 30 | C | AD CS |
> | 31 | C | AD CS |
> | 32 | B | AD CS |
> | 33 | D | AD FS & Webanwendungsproxy |
> | 34 | B | AD FS & Webanwendungsproxy |
> | 35 | A | AD FS & Webanwendungsproxy |
> | 36 | 62 | Netzwerk |
> | 37 | 2001:db8::1 | Netzwerk |
> | 38 | 3268 | AD DS |
> | 39 | 169.254.0.0/16 | Netzwerk |
> | 40 | 53 | Netzwerk |

| Richtige Aufgaben | Punkte | Note (IHK) |
|---|---|---|
| 37-40 | 92,5-100 | 1 - sehr gut |
| 33-36 | 82,5-90 | 2 - gut |
| 27-32 | 67,5-80 | 3 - befriedigend |
| 20-26 | 50-65 | 4 - ausreichend |
| 12-19 | 30-47,5 | 5 - mangelhaft |
| 0-11 | 0-27,5 | 6 - ungenügend |

**Mein Ergebnis:** ___ / 40 richtig = ___ Punkte -> Note ___

**Themen zum Wiederholen:**
- 
