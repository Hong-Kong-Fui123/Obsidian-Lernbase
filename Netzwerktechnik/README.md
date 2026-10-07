# FiSi Windows Server Lernplan – 3 Monate bis Azure 802

## 🎯 Dein Ziel
- **FiSi Abschluss** (Server Admin spezialisiert)
- **Azure 802 Prüfung** vorbereitet
- **3 Monate Intensivvorbereitung** (Schulkurs + Homelab)

---

## 📁 Vault-Struktur

```
Netzwerktechnik/
├── 00_Inbox/          ← Neue Notizen landen hier, 1×/Woche einsortieren
├── 10_Themen/         ← Themen-Übersichten (MOCs): Netzwerk, Windows Server, …
├── 20_Labs/           ← Übungen/Labs (Woche_05 PKI, Lab VPN, Lab AD-Grundlagen)
├── 30_Geräte/         ← VM-Infrastruktur
├── 40_Befehle/        ← Befehlssammlungen zum Nachschlagen
├── 50_Wissen/         ← Erklärungen je Fachgebiet (+ Klausuren)
├── 80_Übersichten/    ← Start, PDF-Index
├── 90_Vorlagen/       ← Vorlagen (Glossar)
├── 99_Anhänge/        ← PDF/<Thema>/…, Dateien (user.csv/ldf), Skripte
└── Glossar/           ← Abkürzungen (Hover-Erklärung)
```

**Einstieg:** [[Start]] · **Unterlagen:** [[PDF-Index]] · **Abkürzungen:** [[00_Glossar-Index]]

> [!info] Inbox-Regel
> Erklärt es *was etwas ist*? → `50_Wissen` · Aufbau/Übung? → `20_Labs` · Befehl? → `40_Befehle`

---

## 🚀 So startest du

### **Für Anfänger in Obsidian:**

1. **Diese Datei öffnen** (du bist hier) ✅
2. **Gehe zu:** [[_MOC_Wochenplan]]
3. **Wähle deine Woche** (z.B. Woche 05)
4. **Lies Aufgabe 1** (60 Min)
5. **Mache sie in deinem Homelab** → notiere Fehler
6. **Vergleiche mit Lösung 1**
7. **Wiederhole mit Aufgabe 2**
8. **Wochenende: Klausur (120 Min)**

---

## 📋 Aufbau pro Aufgabe

```
🎯 Lernziel
✅ Checkliste (zum Abhaken)
📖 Theorie-Zusammenfassung
🔧 Schritt-für-Schritt Anleitung
🖥️ Auf dieser Maschine: EXA-DC01 / EXA-SRV01 / etc.
⚠️ Häufige Fehler & Lösungen
🔍 Validierung (PowerShell-Commands)
🔗 Interne Links zu verwandten Themen
```

---

## 🏗️ Deine Lab-Infrastruktur

| Maschine | OS | Rolle | [[IP]] | [[RAM]] |
|----------|----|----|-------|-----|
| **EXA-DC01** | Windows Server 2022 | Domain Controller (Primary) | 192.168.1.200 | 2 GB |
| **EXA-DC02** | Windows Server 2022 | Domain Controller (Redundanz) | 192.168.1.201 | 2 GB |
| **EXA-CA01** | Windows Server 2022 | Enterprise [[CA]] (Subordinate) | 192.168.1.210 | 2 GB |
| **EXA-SUB-CA01** | Windows Server 2022 | Root CA (Offline) | 192.168.1.211 | 2 GB |
| **EXA-WEB01** | Windows Server 2022 | [[IIS]] + Cert Binding | 192.168.1.220 | 2 GB |
| **EXA-DB01** | Windows Server 2022 | [[SQL]] Server Basics | 192.168.1.221 | 2 GB |
| **EXA-CL01** | Windows 11 | Test Client | 192.168.1.100 | 4 GB |
| **EXA-CL02** | Windows 10 | Test Client (Legacy) | 192.168.1.101 | 4 GB |

**Gesamte RAM-Auslastung:** ~34 GB (von 64 GB) ✅

---

## 📅 Wochenplan

| Tag | Aufgabe | Dauer | Schwierigkeit |
|-----|---------|-------|---|
| Mo | Aufgabe 1 | 60 Min | ⭐ Anfänger |
| Di | Aufgabe 2 | 60 Min | ⭐⭐ Fortgeschrittene |
| Mi | Optional: Extra-Szenario | 60 Min | ⭐⭐ |
| Do | Wiederholung + Fehlersuche | 60 Min | Flexibel |
| Fr | Recap + Theorie-Notizen | 45 Min | 🧠 Theorie |
| Sa-So | Wochenklausur | 120 Min | ⭐⭐⭐ Prüfungslevel |

---

## 🎓 Schulthemen (parallel)

- **Aktuell:** [[GPO]] + Zertifikate
- **Modul 2 Fokus:** [[PKI]], CA-Hierarchie, Zertifikat-Ausrollung
- **Modul 3 (später):** Erweiterte GPO, Security Policies

---

## 💡 Tipps

- **Snapshots machen:** Nach jeder erfolgreichen Übung [[VM]]-Snapshot erstellen
- **Backup der Notizen:** GitHub sync ist aktiv → alles ist gesichert
- **Fehler protokollieren:** in [[Fehlerlog Home-Lab]] dokumentieren
- **Links nutzen:** Mit `[[Link]]` innerhalb Obsidian navigieren

---

## 🔗 Wichtige Seiten

- Start der Woche → **[[_MOC_Wochenplan]]**
- Lab-Übersicht → **[[VM-Infrastruktur]]**
- Snapshot-Recovery → **[[VM-Infrastruktur#📸 Snapshot-Strategie|Snapshot-Strategie]]**

---

**Viel Erfolg!** 🚀  
Dein Lernplan ist modular → du kannst jederzeit zu früheren Wochen zurück.
