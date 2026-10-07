# ✅ Lösung: Aufgabe 01 – PKI-Grundlagen

**Modul:** 2 – Zertifikate & [[PKI]]  
**Aufgabe:** 01  
**Dauer geschätzt:** 45 Minuten zum Vergleichen  

---

## 📋 Antworten zu den Theorie-Fragen

### **Frage 1: Asymmetrische Kryptographie – Warum funktioniert das Handshake ohne vorherige Verabredung?**

**Deine Antwort sollte enthalten:**

**Schritt-für-Schritt Erklärung:**

1. **Browser hat öffentliche Root-CAs gespeichert**
   - Browser vertraut z.B. auf "Symantec", "DigiCert", "Let's Encrypt" (weltweit bekannte CAs)
   - Diese Root-Zertifikate sind bereits im Browser installiert

2. **Server sendet sein Zertifikat**
   - Server: "Hier ist mein Zertifikat (mit meinem Public Key)"
   - Zertifikat ist signiert von einer [[CA]], die der Browser kennt

3. **Browser validiert die Signatur**
   - Browser: "Ich kenne die CA, die das signiert hat"
   - Browser nutzt die CA's Public Key → validiert die Signatur ✅

4. **Handshake kann starten**
   - Browser: "Ich vertraue dir, hier ist ein verschlüsselter Session-Key"
   - Server (mit eigenem Private Key) kann diesen entschlüsseln
   - Ab jetzt: symmetrische Verschlüsselung für Datenstrom

**Warum ohne vorherige Verabredung?**
- Der Browser brauchte den Server's Public Key NICHT vorher zu kennen
- Der Server beweist aber via Zertifikat, dass er der richtige ist
- Die CA ist der "Notar" dazwischen

**Deine Antwort war gut wenn:**
- ✅ Public Key wird vom Server gesendet
- ✅ Browser vertraut der CA (nicht dem Server direkt)
- ✅ Signatur wird mit CA's Public Key validiert

---

### **Frage 2: Warum ist Root CA Offline sicherer?**

**Deine Antwort sollte enthalten:**

**Die Sicherheits-Logik:**

```
SZENARIO A: Root CA ist ONLINE
├─ Hacker hackt Root CA
├─ Hacker kann alle Zertifikate fälschen
├─ Hacker kann sein eigenes Root-Zertifikat erstellen
├─ Browser vertraut immer noch (weil Root vertraut wird)
└─ ❌ KATASTROPHE – ganze PKI-Infrastruktur kompromittiert

SZENARIO B: Root CA ist OFFLINE
├─ Hacker hackt Subordinate CA (EXA-CA01)
├─ Hacker kann Zertifikate von Sub-CA fälschen
├─ Browser: "Sub-CA signiert diesen Fake... lass mich Root überprüfen"
├─ Root CA ist offline → kann neu gestartet werden
├─ Root CA kann Subordinate widerrufen (CRL)
└─ ✅ Schaden begrenzt – nur Sub-CA betroffen
```

**Warum ist Offline besser?**
- Root ist **selbstsigniert** (vertraut auf sich selbst)
- Wenn Root gehackt, muss globales Trust reinstated → Monate Arbeit
- Wenn Sub gehackt, nur diese Sub deaktivieren → Stunden

**Deine Antwort war gut wenn:**
- ✅ Root-Kompromittierung = Katastrophe
- ✅ Sub-Kompromittierung = begrenzt
- ✅ Offline = schwerer zu hacken

---

### **Frage 3: Zertifikat von gehackter Sub-CA – Was passiert?**

**Deine Antwort sollte enthalten:**

| Frage | Antwort | Begründung |
|-------|---------|-----------|
| **a) Root kann neue Sub signieren?** | ✅ **JA** | Root ist offline, sauber, kann wieder online gehen und neue Sub-CA zertifizieren |
| **b) Alte Zerts noch gültig bis [[CRL]] check?** | ✅ **JA (bis CRL aktualisiert)** | Browser cached Zertifikate, kennt CRL vielleicht nicht sofort. Nach CRL-Update = widerrufen |
| **c) Root auch kompromittiert?** | ❌ **NEIN** | Root ist offline, wurde nicht gehackt – nur Sub |

**Detaillierte Erklärung:**

```
Hacker hackt EXA-CA01 (Sub-CA online)
├─ Kann Zertifikate fälschen mit Sub-CA Private-Key
├─ Browser prüft: "Issuer = Example.com Enterprise CA"
├─ Browser prüft: "Issuer's Issuer = Root CA"
├─ Browser: "Root vertraue ich... aber Sub ist in meiner CRL?"
│
└─ Moment 1 (Browser-Cache alt): Zertifikat noch gültig
└─ Moment 2 (CRL aktualisiert): Zertifikat = widerrufen ❌
└─ Moment 3 (Root signiert neue Sub): neue CA einsatzbereit
```

**Deine Antwort war gut wenn:**
- ✅ Root kann immer neu signieren
- ✅ alte Zerts bleiben gültig bis CRL-Update
- ✅ Root ist nicht kompromittiert (= das ist die Sicherheit)

---

### **Frage 4: Server-Zertifikat gehackt – Wie erfährt der Browser davon?**

**Deine Antwort sollte enthalten:**

**Drei Mechanismen (in Reihenfolge):**

1. **CRL (Certificate Revocation List) – die klassische Methode**
   ```
   Browser prüft: "Ist dieses Zertifikat in der CRL?"
   └─ CRL steht im Zertifikat (CDP Extension)
   └─ Wird regelmäßig vom Browser aktualisiert
   └─ "Widerrufen am 15.11.2025 – Reason: keyCompromise"
   ```

2. **[[OCSP]] (Online Certificate Status Protocol) – Live-Abfrage**
   ```
   Browser fragt OCSP-Server: "Ist Zertifikat XYZ noch gültig?"
   └─ OCSP gibt Real-Time Antwort: "Nein, widerrufen"
   └─ Schneller als CRL-Download
   ```

3. **OCSP Stapling – Zertifikat trägt seine eigene Status-Info**
   ```
   Server sendet Zertifikat + OCSP-Response
   └─ Browser muss nicht selbst nachfragen
   └─ Schneller + datenschutzfreundlicher
   ```

**In deinem Homelab (Woche 07):**
- Wir konfigurieren CRL und OCSP auf EXA-CA01
- Du testest beide Methoden

**Deine Antwort war gut wenn:**
- ✅ Mindestens CRL oder OCSP genannt
- ✅ Verstanden, dass es automatisch passiert
- ✅ Weiß, dass [[CDP]] im Zertifikat auf CRL verweist

---

### **Frage 5: Subject vs. Issuer – Was bedeutet das?**

**Deine Antwort sollte enthalten:**

```
Subject: CN=exa-web01.example.com
└─ "Für WEN ist dieses Zertifikat?"
└─ Antwort: Für den Server "exa-web01"
└─ Diese Maschine nutzt diesen Private Key

Issuer: CN=Example.com Enterprise CA
└─ "WER hat dieses Zertifikat ausgestellt?"
└─ Antwort: Die Enterprise CA der example.com Domäne
└─ Die CA hat das mit ihrem Private-Key signiert

BEISPIEL:
├─ Zertifikat = "Reisepass"
├─ Subject = "Wessen Pass? Hans Müller"
├─ Issuer = "Ausgestellt von: Bundesamt für Migration"
└─ Unterschrift = "Unterschrift des Beamten" (Issuer Private-Key)
```

**Wichtig zu verstehen:**
- Subject und Issuer können gleich sein (selbstsigniert = Root-CA)
- Bei End-Entity: Subject ≠ Issuer (normal)

**Beispiele:**

```
ROOT-CA ZERTIFIKAT:
├─ Subject: CN=Example.com Root CA
├─ Issuer: CN=Example.com Root CA    ← GLEICH! (selbstsigniert)

SUBORDINATE-CA ZERTIFIKAT:
├─ Subject: CN=Example.com Enterprise CA
├─ Issuer: CN=Example.com Root CA    ← UNTERSCHIEDLICH

END-ENTITY (WEBSERVER):
├─ Subject: CN=exa-web01.example.com
├─ Issuer: CN=Example.com Enterprise CA    ← UNTERSCHIEDLICH
```

**Deine Antwort war gut wenn:**
- ✅ Subject = "Für wen"
- ✅ Issuer = "Von wem"
- ✅ Unterschied Root (Subject=Issuer) vs. Sub/End (Subject≠Issuer) verstanden

---

## 🎓 Konzept-Zusammenfassung (deine Notizen überprüfen)

**Kontrolliere, ob deine Obsidian-Notizen enthalten:**

### **Notiz 1: Asymmetrische Kryptographie**
```
📝 Notiz-Checklist:
- [ ] Public Key (öffentlich, zum Verschlüsseln)
- [ ] Private Key (geheim, zum Signieren/Entschlüsseln)
- [ ] Mathematischer Zusammenhang (RSA 2048-bit z.B.)
- [ ] Beispiel: Browser + Server
```

### **Notiz 2: Certificate Authority**
```
📝 Notiz-Checklist:
- [ ] Was ist eine CA?
- [ ] Rollen: Identität verifizieren, Zertifikate ausstellen, widerrufen
- [ ] Root CA (offline, selbstsigniert)
- [ ] Subordinate CA (online, von Root signiert)
- [ ] Enterprise CA (in AD integriert)
```

### **Notiz 3: PKI-Hierarchie**
```
📝 Notiz-Checklist:
- [ ] Root → Subordinate → End-Entity
- [ ] Warum hierarchisch? (Sicherheit, Isolation)
- [ ] Dein Lab-Aufbau: SUB-CA01 (Root) → CA01 (Sub) → Server/Clients
```

### **Notiz 4: Trust-Chain**
```
📝 Notiz-Checklist:
- [ ] Wie Browser vertraut (Signatur-Validierung)
- [ ] CDP, CRL, OCSP (Begriffe)
- [ ] Certificate Revocation (widerrufen bei Hack/Ablauf)
```

---

## ⚠️ Häufige Verständnis-Fehler (deine Antworten überprüfen)

| Fehler | Richtig | Merkhilfe |
|--------|---------|-----------|
| "Root CA sollte online sein, damit schneller" | ❌ Root IMMER offline | Online = Angriffsvektor #1 |
| "Alle Zertifikate werden sofort widerrufen" | ❌ CRL braucht Zeit | Browser cached CRL, aktualisiert später |
| "Private Key kann mit Root teilen" | ❌ NIEMALS teilen | Private = Privat! Nur Owner |
| "Certificate verschlüsselt Daten" | ❌ Beglaubigt nur Identität | Verschlüsselung kommt danach ([[TLS]] Handshake) |
| "Subject und Issuer sind immer gleich" | ❌ Nur bei Root | Sub + End haben andere Subject/Issuer |

---

## 🔍 Selbst-Validierung: Hast du wirklich verstanden?

**Beantworte spontan (ohne nachzuschauen):**

1. **Q:** Warum braucht der Browser deinen WebServer's Private Key nicht zu kennen?
   - **A:** Weil der Browser der CA vertraut, die das Zertifikat signiert hat. Die CA's Public Key reicht zum Validieren.

2. **Q:** Welche Rolle hat die Root CA?
   - **A:** Vertraut auf sich selbst, signiert Sub-CAs, bleibt offline.

3. **Q:** Was ist CDP?
   - **A:** CRL Distribution Point – [[URL]] im Zertifikat, wo die Revocation-Liste steht.

4. **Q:** Kannst du ein Zertifikat selbst ausstellen?
   - **A:** Nur wenn du eine CA bist (ab Aufgabe 02!). Sonst brauchst du die Vertrauensperson (CA).

5. **Q:** Ist "Subject: exa-web01" derselbe wie "Issuer: exa-web01"?
   - **A:** Nein. Subject = Wem gehört es. Issuer = Wer hat es signiert.

---

## 📊 Wissensstand nach Aufgabe 01

**Wenn du alle Fragen korrekt beantwortet hast:**

| Konzept | Verstanden? | Nächster Schritt |
|---------|------------|---|
| Asymmetrische Kryptographie | ✅ | Aufgabe 02: praktisch anwenden |
| CA-Hierarchie | ✅ | Aufgabe 02: Root-CA installieren |
| Trust-Chain | ✅ | Aufgabe 02: Validierung testen |
| PKI-Konzepte | ✅ | Aufgabe 02: praktisch konfigurieren |

**Wenn noch unklar:**
- [ ] Lese Abschnitt erneut
- [ ] Schreibe Fragen auf
- [ ] Vergleiche mit [[70-742_Server2016_Identitaet.pdf#page=291|Andrew Warren: Zertifikate]] (Schulbuch, 70-742 Kap. 4)
- [ ] Stelle Fragen an Claude

---

## 🚀 Bereit für Aufgabe 02?

**Aufgabe 02 (Dienstag) baut darauf auf:**
- Du brauchst diese Konzepte nicht perfekt zu verstehen
- Aber die Grundidee sollte klar sein
- **Praktisches Handwerk** wird in Aufgabe 02 erlernt

---

## 🔗 Zurück zur Übersicht

- [[_MOC_Wochenplan]] – Wochenübersicht
- [[Aufgabe_01_PKI-Grundlagen]] – zurück zur Aufgabe
- [[Woche_05/Aufgabe_02_CA-Serverrolle]] – nächste Aufgabe (Dienstag)

---

**Herzlichen Glückwunsch!** 🎓  
Du verstehst jetzt PKI-Grundlagen. Morgen wird es praktisch! 🚀
