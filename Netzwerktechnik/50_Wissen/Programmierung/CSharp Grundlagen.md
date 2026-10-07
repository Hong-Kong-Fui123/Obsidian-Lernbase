---
typ: wissen
thema: Programmierung
tags: [csharp, programmierung]
quelle: Word-Notizen
status: importiert
aliases: [C# Grundlagen, CSharp]
---
# C# Grundlagen

Thema: [[Programmierung]]

Das System, in dem die Befehle stattfinden, ist hervorgehoben.

MAIN-Klasse ist  in diesem Fall die Grundlage.

- Hier ist eine kompakte Übersicht wichtiger **einzelner Programmbefehle in C#** mit Erklärung und Beispiel.
    Ich gehe dabei von der klassischen Konsolenprogrammierung aus.

- **1. Variablen deklarieren**
- **Csharp**
- int zahl = 10;       // Ganze Zahl
- double pi = 3.14;    // Kommazahl
- string name = "Max"; // Text
- bool aktiv = true;   // Wahr/Falsch
- **Deklaration**: Speicherplatz für einen Wert reservieren.

- **Initialisierung**: Direkt einen Startwert zuweisen.

- **2. Ausgabe auf der Konsole**
- **Csharp**
- Console.WriteLine("Hallo Welt"); // Mit Zeilenumbruch
- Console.Write("Ohne Umbruch");   // Ohne Zeilenumbruch

- WriteLine fügt automatisch einen Zeilenumbruch hinzu.

- Write schreibt nur den Text.

- **3. Eingabe von der Konsole**
- **Csharp**
- string eingabe = Console.ReadLine(); // Liest eine ganze Zeile als String
- int zahl = int.Parse(eingabe);       // Umwandeln in int (Achtung: Fehler bei falscher Eingabe)

- Für sichere Umwandlung:

- **Csharp**
- if (int.TryParse(eingabe, out int wert))
-     Console.WriteLine($"Zahl: {wert}");
- else
-     Console.WriteLine("Ungültige Eingabe");

- **4. Bedingungen (if / else)**
- **Csharp**
- if (zahl > 0)
-     Console.WriteLine("Positiv");
- else if (zahl < 0)
-     Console.WriteLine("Negativ");
- else
-     Console.WriteLine("Null");

- Steuert den Programmfluss abhängig von Bedingungen.

- **5. Schleifen**
- **for-Schleife** (feste Anzahl Durchläufe):
- **Csharp**
- for (int i = 0; i < 5; i++)
-     Console.WriteLine(i);
- **while-Schleife** (läuft, solange Bedingung wahr ist):
- **Csharp**
- int count = 0;
- while (count < 5)
- {
-     Console.WriteLine(count);
-     count++;
- }
- **foreach-Schleife** (über eine Sammlung iterieren):
- **Csharp**
- string[] namen = { "Anna", "Ben", "Chris" };
- foreach (string n in namen)
-     Console.WriteLine(n);

- **6. Methoden**
- **Csharp**
- static int Addiere(int a, int b)
- {
-     return a + b;
- }

- int summe = Addiere(3, 4);
- Console.WriteLine(summe);

- Methoden helfen, Code zu strukturieren und wiederzuverwenden.

- **7. Kommentare**
- **Csharp**
- // Einzeiliger Kommentar

- /*
-    Mehrzeiliger
-    Kommentar
- */

- Kommentare werden vom Compiler ignoriert und dienen nur zur Erklärung.

- ✅ **Tipp:** In C# endet **jede Anweisung** mit einem **Semikolon** ;.
    Mehrere Anweisungen können mit { ... } zu einem Block zusammengefasst werden.

    Möchtest du, dass ich das mache?

Einfügen der PapDesigner in Programmierzeilen

¦

1.                      static void OpenFile(string path)
        {

2.

3.                           Process.Start(new ProcessStartInfo
            {
                FileName = path,
                UseShellExecute = true
            });
        }
