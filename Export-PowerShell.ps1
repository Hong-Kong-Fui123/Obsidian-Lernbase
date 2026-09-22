# Quelldatei
$Quelle = ".\FiSi_Grundlagen.md"

# Zieldatei
$Ziel = ".\PowerShell.md"

# Datei einlesen
$Inhalt = Get-Content $Quelle -Raw

# Überschriften/Abschnitte, die wir NICHT automatisch übernehmen wollen
# Hier kannst du später selbst festlegen, was gefiltert werden soll.

$PowerShellAbschnitte = @(
    "## PowerShell – Grundlagen",
    "## PowerShell – AD & Domain",
    "## Format in PowerShell anpassen",
    "## Zusätzliche Befehle"
)

# Ergebnis zunächst leer machen
$Ergebnis = "# PowerShell`r`n`r`n"

foreach ($Abschnitt in $PowerShellAbschnitte) {

    # Position des Abschnitts finden
    $Start = $Inhalt.IndexOf($Abschnitt)

    if ($Start -ge 0) {

        # Ende des Abschnitts = nächste Überschrift mit ## 
        $Rest = $Inhalt.Substring($Start + $Abschnitt.Length)

        $Ende = $Rest.IndexOf("`r`n## ")

        if ($Ende -lt 0) {
            $Ende = $Rest.IndexOf("`n## ")
        }

        if ($Ende -ge 0) {
            $Text = $Rest.Substring(0, $Ende)
        }
        else {
            $Text = $Rest
        }

        # Abschnitt hinzufügen
        $Ergebnis += $Abschnitt + $Text + "`r`n"
    }
}

# Ergebnis speichern
Set-Content -Path $Ziel -Value $Ergebnis -Encoding UTF8

Write-Host "Export abgeschlossen."
Write-Host "Ergebnis: $Ziel"
