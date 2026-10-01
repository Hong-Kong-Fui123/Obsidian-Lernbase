# 📖 Aufgabe 01: PKI-Grundlagen verstehen

**Modul:** 2 – Zertifikate & [[PKI]]  
**Woche:** 05 (Montag)  
**Dauer:** 60 Minuten  
**Schwierigkeit:** ⭐ Anfänger  
**Maschinen:** Nur Theorie (keine [[VM]]-Zugriffe nötig)  

---

## 🎯 Lernziel dieser Aufgabe

Nach dieser Aufgabe kannst du:
- ✅ Asymmetrische Verschlüsselung erklären (Public-Key + Private-Key)
- ✅ Certificate Authority ([[CA]]) Rollen verstehen
- ✅ PKI-Hierarchie (Root → Subordinate → End-Entity) erklären
- ✅ Trust-Chain und Zertifikat-Verifizierung verstehen
- ✅ Unterschied zwischen Standalone CA und Enterprise-CA kennen
- ✅ Schulbuch-Kapitel selbstständig in deinen Lab abbilden

---

## ✅ Checkliste

- [ ] Abschnitt 1: Asymmetrische Kryptographie gelesen
- [ ] Abschnitt 2: Certificate Authority Konzept gelesen
- [ ] Abschnitt 3: PKI-Hierarchie verstanden
- [ ] Abschnitt 4: Trust-Chain nachvollzogen
- [ ] Abschnitt 5: CA-Typen differenziert
- [ ] Theorie-Fragen beantwortet (unten)
- [ ] Mit Schulbuch abgeglichen (Andrew Warren: Zertifikate)
- [ ] Notizen in Obsidian angelegt

---

## 📚 Theorieteil

### **1. Asymmetrische Verschlüsselung (Basis-Konzept)**

**Was ist das?**  
Asymmetrische Verschlüsselung nutzt zwei mathematisch verknüpfte Schlüssel:

```
🔑 PUBLIC KEY (öffentlich)
   ├─ Jeder kann damit verschlüsseln
   ├─ Jeder darf ihn haben
   └─ Zu jedem Server abrufbar

🔐 PRIVATE KEY (geheim)
   ├─ Nur der Besitzer hat ihn
   ├─ Darf nie raus
   └─ Zum Entschlüsseln/Signieren nötig
```

**Beispiel: Webserver mit [[HTTPS]]**

```
1. Browser fragt: "Hallo exa-web01.example.com, zeig mir dein Public-Key!"
2. Server sendet: sein Zertifikat + Public-Key
3. Browser: "Ich vertraue dir (Validierung), hier ist eine verschlüsselte Session-ID"
4. Server (mit Private-Key): "Ich entschlüssle das... gut, wir können kommunizieren"
5. Nachricht verschlüsselt Hin und Her (symmetric mit Session-Key)
```

**Warum wichtig?**
- Ohne Asymmetrie → kein sicheres Handshake möglich
- Mit Asymmetrie → Browser kann Server vertrauen (ohne Key vorab zu kennen)

---

### **2. Certificate Authority (CA) – Die zentrale Vertrauensperson**

**Was ist eine CA?**  
Eine CA ist eine vertrauenswürdige Organisation/Server, die:
- ✅ **Identitäten verifiziert** (z.B. "Du bist wirklich exa-web01.example.com")
- ✅ **Zertifikate ausstellt** (mit eigenem Private-Key signiert)
- ✅ **Zertifikate widerruft** (wenn kompromittiert, abgelaufen)
- ✅ **Eine Trust-Chain aufbaut** (Hierarchie)

**In deinem Homelab:**

| CA-Typ | Rolle | In deinem Lab | Sicherheit |
|--------|-------|----------------|-----------|
| **Root CA** | Vertraut auf sich selbst (selbstsigniert) | EXA-SUB-CA01 (OFFLINE) | ⭐⭐⭐⭐⭐ |
| **Subordinate CA** | Vertraut auf Root, stellt Certs aus | EXA-CA01 (online) | ⭐⭐⭐⭐ |
| **End-Entity** | Normale Server/Client Zertifikate | EXA-WEB01, Clients | ⭐⭐⭐ |

---

### **3. PKI-Hierarchie – Die Vertrauenskette**

**Wie vertraut der Browser dem Server?**

```
🌍 Browser (Microsoft, Apple, Mozilla)
   └─ hat vordefinierte Root-CAs (z.B. Symantec, DigiCert, Letsencrypt)

🌐 Welt-Wide Web Server (z.B. google.com)
   └─ hat Zertifikat von GeoTrust (Subordinate von Symantec)

✅ VERTRAUEN CHAIN:
   Browser kennt Symantec
   → Symantec hat GeoTrust signiert
   → GeoTrust hat google.com signiert
   → Browser vertraut google.com ✅
```

**In deinem Homelab (Offline-PKI):**

```
🏢 EXAMPLE.COM PKI HIERARCHIE

Root CA (Offline)
   └─ EXA-SUB-CA01 (Windows Server 2022 – OFFLINE)
       │
       └─ Erstellt EIN Zertifikat für Subordinate CA
           (und dann off gehen)

       ↓

Subordinate CA (Online, Enterprise)
   └─ EXA-CA01 (Windows Server 2022 – ONLINE in example.com)
       │
       ├─ Stellt aus: Server-Zertifikate
       │  └─ exa-web01.example.com (IIS)
       │
       ├─ Stellt aus: Client-Zertifikate
       │  └─ thomas.klein@example.com (SmartCard sim.)
       │
       └─ Stellt aus: Code-Signing Certs
          └─ Code Signer Cert

End-Entity Certificates (Client + Server)
   └─ Sind von EXA-CA01 signiert
```

**Sicherheits-Logik:**
- Root ist offline → kann nicht gehackt werden ✅
- Subordinate ist online → KANN gehackt werden, aber nur Sub-Certs kompromittiert
- Wenn Sub kompromittiert → Root ist noch sicher, Root CA kann neu signieren

---

### **4. Certificate (Zertifikat) – Die Bescheinigung**

**Was steht in einem Zertifikat?**

```
Zertifikat für: exa-web01.example.com
├─ Subject:           CN=exa-web01.example.com
├─ Issuer:            CN=Example.com Enterprise CA
├─ Serial Number:     0x1A2B3C4D5E6F...
├─ Validity:
│  ├─ Issued:         01.01.2025 10:00
│  └─ Expires:        01.01.2026 10:00 (1 Jahr gültig)
├─ Public Key:        -----BEGIN PUBLIC KEY-----
├─ Signature:         [Signatur der Root CA]
├─ Extension - AKI:   Authority Key Identifier
├─ Extension - SKI:   Subject Key Identifier
└─ Extension - CDP:   CRL Distribution Point
```

**Key-Informationen:**
- **Subject:** "Wem gehört dieses Zertifikat?"
- **Issuer:** "Wer hat dieses Zertifikat ausgestellt?"
- **Validity:** "Wie lange ist es gültig?"
- **Signature:** "Beweis, dass Issuer das signiert hat"
- **[[CDP]]:** "Wo kann ich die [[CRL]] (Revocation-Liste) finden?"

---

### **5. Trust Chain Validation (Vertrauensketten-Überprüfung)**

**Wie validiert der Browser?**

```
Client (Browser) prüft:
┌─────────────────────────────────────┐
│ 1. Ist das Zertifikat gültig?       │
│    └─ heute zwischen Issued + Expires?
│                                      │
│ 2. Hat der Issuer es wirklich       │
│    signiert?                         │
│    └─ Signature mit Issuer Public-Key
│       verifiable?                    │
│                                      │
│ 3. Kenne ich den Issuer?             │
│    └─ Ist Issuer selbst (oder sein   │
│       Issuer) in meinem Trust Store? │
│                                      │
│ 4. Ist das Zertifikat widerrufen?   │
│    └─ Check der CRL oder OCSP        │
│                                      │
│ 5. Passt der Subject zur URL?        │
│    └─ exa-web01.example.com ✅       │
│       vs. evil-site.example.com ❌   │
└─────────────────────────────────────┘
```

**In deinem Lab:**
- Browser kennt deine "Example.com Root CA" nicht
- → Zertifikat wird als "ungültig" angezeigt ⚠️
- → Du musst Root-Zertifikat zum Browser hinzufügen (Woche 06)

---

## 🤔 Theorie-Fragen (selbst beantworten)

**Beantworte diese Fragen (schreib Antworten in Obsidian):**

### **Frage 1: Asymmetrische Kryptographie**
**Q:** Warum kann dein Browser mit deinem Webserver sprechen, obwohl keine vorherige Verabredung über Schlüssel stattfand?

**Hinweis:** Denk an Public + Private Key Konzept.

---

### **Frage 2: Root CA Offline**
**Q:** Warum ist es sicherer, die Root CA (EXA-SUB-CA01) offline zu halten?

**Hinweis:** Was passiert wenn sie gehackt wird?

---

### **Frage 3: Trust Chain**
**Q:** Wenn EXA-CA01 gehackt wird, kann dann:
- a) Die Root CA neue Sub-CAs signieren? (JA/NEIN)
- b) Alte Zertifikate von gehackter CA noch gültig? (JA/NEIN bis CRL check)
- c) Die Root ist auch kompromittiert? (JA/NEIN)

**Begründe kurz.**

---

### **Frage 4: Certificate Revocation**
**Q:** Dein Web-Server-Zertifikat (exa-web01) ist gehackt. Wie erfährt der Browser davon?

**Hinweis:** CDP Extension, CRL, [[OCSP]]

---

### **Frage 5: Subject vs. Issuer**
**Q:** Ein Zertifikat hat:
- Subject: CN=exa-web01.example.com
- Issuer: CN=Example.com Enterprise CA

Was bedeutet das?

---

## 📖 Schulbuch-Zuordnung

**Andrew Warren: "Zertifikate & PKI"**  
(Falls vorhanden, lies diese Kapitel parallel)

| Schulbuch-Kapitel | Unser Theorie-Abschnitt | Mapping |
|-------------------|--------------------------|---------|
| 1: PKI Grundlagen | Abschnitt 1-2 | Asymmetrie + CA-Konzept |
| 2: Zertifikate | Abschnitt 4 | Was in einem Zertifikat steht |
| 3: Vertrauensmodelle | Abschnitt 3, 5 | Hierarchie + Validierung |
| 4: CRL & Revocation | (Woche 07) | Certificate Revocation |

---

## 🔍 Validierungs-Checkliste

### **Hast du wirklich verstanden?**

Beantworte ohne in deine Notizen zu schauen:

- [ ] Public Key vs. Private Key Unterschied
- [ ] Warum Root CA offline sein sollte
- [ ] Unterschied Root-CA, Sub-CA, End-Entity
- [ ] Wie Browser vertrauen aufbaut (Chain)
- [ ] Was CDP, CRL, OCSP sind (Begriffe)
- [ ] Unterschied Standalone CA vs. Enterprise CA

**Wenn alle gehört ✅** → bereit für Aufgabe 02!

---

## 💡 Häufige Verständnis-Fehler

❌ **FEHLER 1:** "Private Key sollte man mit Root-CA teilen"  
✅ **RICHTIG:** Private Key NIEMALS raus! Nur Public Key.

---

❌ **FEHLER 2:** "Wenn Root gehackt wird, ist alles verloren, aber Sub-CA nicht"  
✅ **RICHTIG:** Wenn Root gehackt, müssen alle Root-Zertifikate Browser zurückgestuft werden (große Arbeit). Darum Offline-Strategie.

---

❌ **FEHLER 3:** "Zertifikate verschlüsseln die Nachricht"  
✅ **RICHTIG:** Zertifikate **beglaubigen** die Identität. Verschlüsselung kommt danach (via symmetric cipher).

---

## 🔗 Verwandte Inhalte

- [[Lösung_01_PKI-Grundlagen]] (nach Aufgabe)
- [[VM-Infrastruktur]] (dein Lab setup)
- [[_MOC_Wochenplan]] (zurück zum Plan)
- [[Woche_05/Aufgabe_02_CA-Serverrolle]] (nächste Aufgabe)

---

## 🎓 Nach dieser Aufgabe

**Montag Abend:** Diese Aufgabe fertig ✅

**Dienstag Morgen:** Aufgabe 02 starten → Praktisches Handwerk beginnt!

---

**Viel Erfolg mit der Theorie!** 🧠  
Die praktischen Übungen kommen gleich.
