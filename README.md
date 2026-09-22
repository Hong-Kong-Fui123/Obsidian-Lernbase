# FiSi Windows Server Lernplan – 3 Monate bis Azure 802

## 🎯 Dein Ziel
- **FiSi Abschluss** (Server Admin spezialisiert)
- **Azure 802 Prüfung** vorbereitet
- **3 Monate Intensivvorbereitung** (Schulkurs + Homelab)

---

## 📁 Vault-Struktur

```
FiSi-Lernplan-Windows-Server/
├── README.md                    ← Du bist hier
├── _MOC_Wochenplan.md          ← Start: Wöchentliche Übersicht
├── 
├── Woche_05-08/                ← MODUL 2: Zertifikate (PKI)
│   ├── Woche_05/
│   │   ├── Aufgabe_01_PKI-Grundlagen.md
│   │   ├── Lösung_01_PKI-Grundlagen.md
│   │   ├── Aufgabe_02_CA-Serverrolle.md
│   │   ├── Lösung_02_CA-Serverrolle.md
│   │   ├── Klausur_Zertifikate_120Min.md
│   │   └── Klausur_Lösung.md
│   ├── Woche_06/
│   ├── Woche_07/
│   └── Woche_08/
│
├── Netzwerk-Infos/
│   ├── VM-Infrastruktur.md      ← Deine erweiterte Lab-Umgebung
│   ├── IP-Management.md
│   └── Firewall-Regeln.md
│
├── Snapshots/
│   ├── Snapshot-States.md       ← Startzustände für jede Übung
│   └── Restore-Guide.md
│
└── Archiv/                      ← Abgeschlossene Module (später)
    └── Woche_01-04/             (MODUL 1: AD Grundlagen – bereits gemacht)
```

---

## 🚀 So startest du

### **Für Anfänger in Obsidian:**

1. **Diese Datei öffnen** (du bist hier) ✅
2. **Gehe zu:** `_MOC_Wochenplan.md`
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

| Maschine | OS | Rolle | IP | RAM |
|----------|----|----|-------|-----|
| **EXA-DC01** | Windows Server 2022 | Domain Controller (Primary) | 192.168.1.200 | 2 GB |
| **EXA-DC02** | Windows Server 2022 | Domain Controller (Redundanz) | 192.168.1.201 | 2 GB |
| **EXA-CA01** | Windows Server 2022 | Enterprise CA (Subordinate) | 192.168.1.210 | 2 GB |
| **EXA-SUB-CA01** | Windows Server 2022 | Root CA (Offline) | 192.168.1.211 | 2 GB |
| **EXA-WEB01** | Windows Server 2022 | IIS + Cert Binding | 192.168.1.220 | 2 GB |
| **EXA-DB01** | Windows Server 2022 | SQL Server Basics | 192.168.1.221 | 2 GB |
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

- **Aktuell:** GPO + Zertifikate
- **Modul 2 Fokus:** PKI, CA-Hierarchie, Zertifikat-Ausrollung
- **Modul 3 (später):** Erweiterte GPO, Security Policies

---

## 💡 Tipps

- **Snapshots machen:** Nach jeder erfolgreichen Übung VM-Snapshot erstellen
- **Backup der Notizen:** GitHub sync ist aktiv → alles ist gesichert
- **Fehler protokollieren:** Im Ordner `Fehlerlog.md` dokumentieren
- **Links nutzen:** Mit `[[Link]]` innerhalb Obsidian navigieren

---

## 🔗 Wichtige Seiten

- Start der Woche → **[[_MOC_Wochenplan]]**
- Lab-Übersicht → **[[VM-Infrastruktur]]**
- Snapshot-Recovery → **[[Snapshot-States]]**

---

**Viel Erfolg!** 🚀  
Dein Lernplan ist modular → du kannst jederzeit zu früheren Wochen zurück.
