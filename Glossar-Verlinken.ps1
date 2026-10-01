<#
  Glossar-Verlinken.ps1
  Maschine: Schul-PC (Windows Server 2022, PowerShell 5.1)
  Setzt [[Links]] auf Glossarbegriffe in allen Notizen des Vaults.
  - Standard = Testlauf (zeigt nur an). Schreiben erst mit -Apply.
  - Nur ERSTES Vorkommen je Begriff und Notiz wird verlinkt.
  - Übersprungen: Ordner Glossar, Vorlagen, .obsidian, .git; Frontmatter,
    Codeblöcke, Inline-Code, Überschriften, vorhandene Links, URLs, HTML-Tags.
  - Groß-/Kleinschreibung wird beachtet (DNS ja, dns nein).
#>
param(
  [string]$Vault = 'C:\Users\ITA7-TN10\Downloads\Netzwerktechnik',
  [switch]$Apply
)

$glossarDir = Join-Path $Vault 'Glossar'
$skipDirs   = 'Glossar','Vorlagen','.obsidian','.git'

# Begriffe = Dateinamen im Glossar, längste zuerst (AD DS vor AD, IP-HTTPS vor IP)
$terms = Get-ChildItem $glossarDir -Filter *.md |
  Where-Object { $_.BaseName -notlike '00_*' } |
  ForEach-Object { $_.BaseName } |
  Sort-Object Length -Descending

$rxTerms = @{}
foreach ($t in $terms) {
  $e = [regex]::Escape($t)
  $rxTerms[$t] = [regex]"(?<![\w\[\-\\.])$e(?![\w\]\\]|\.\w)"
}
# Bereiche, die nicht verändert werden: Wikilinks, MD-Links, Inline-Code, URLs, HTML
$mask = [regex]'(\[\[[^\]]*\]\]|\[[^\]]*\]\([^)]*\)|`[^`]*`|https?://\S+|<[^>]+>)'
$utf8 = New-Object System.Text.UTF8Encoding($false)   # ohne BOM (wichtig für Obsidian-Eigenschaften)

$files = Get-ChildItem $Vault -Recurse -Filter *.md | Where-Object {
  $rel = $_.FullName.Substring($Vault.Length).TrimStart('\')
  -not ($skipDirs | Where-Object { $rel -like "$_\*" })
}

$total = 0
foreach ($f in $files) {
  $text  = [IO.File]::ReadAllText($f.FullName)
  $lines = $text -split "`n"
  $done  = @{}
  foreach ($t in $terms) { if ($text -cmatch "\[\[$([regex]::Escape($t))(\||\]\]|#)") { $done[$t] = $true } }

  $inFront = $false; $inCode = $false
  for ($i = 0; $i -lt $lines.Count; $i++) {
    $l = $lines[$i]; $trim = $l.Trim()
    if ($i -eq 0 -and $trim -eq '---') { $inFront = $true; continue }
    if ($inFront) { if ($trim -eq '---') { $inFront = $false }; continue }
    if ($trim -match '^(```|~~~)') { $inCode = -not $inCode; continue }
    if ($inCode -or $trim -match '^#') { continue }

    foreach ($t in $terms) {
      if ($done[$t]) { continue }
      $parts = $mask.Split($l)                   # gerade Indizes = normaler Text
      for ($p = 0; $p -lt $parts.Count; $p += 2) {
        if ($rxTerms[$t].IsMatch($parts[$p])) {
          $parts[$p] = $rxTerms[$t].Replace($parts[$p], "[[$t]]", 1)
          $done[$t] = 'neu'; break
        }
      }
      $l = -join $parts
    }
    $lines[$i] = $l
  }

  $neu = @($done.Keys | Where-Object { $done[$_] -eq 'neu' } | Sort-Object)
  if ($neu.Count) {
    $total += $neu.Count
    Write-Host ("{0}: {1}" -f $f.FullName.Substring($Vault.Length+1), ($neu -join ', ')) -ForegroundColor Cyan
    if ($Apply) { [IO.File]::WriteAllText($f.FullName, ($lines -join "`n"), $utf8) }
  }
}

if ($Apply) { Write-Host "Fertig: $total Links gesetzt." -ForegroundColor Green }
else        { Write-Host "Testlauf: $total Links würden gesetzt. Schreiben mit -Apply." -ForegroundColor Yellow }
