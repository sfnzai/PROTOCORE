# === build_archive.ps1
. "$PSScriptRoot\..\config\globals.ps1"

$pages = Get-ChildItem -Path $signalHtmlDir -Recurse -Filter "*.html" | Sort-Object LastWriteTime -Descending
$archive = @{}

foreach ($file in $pages) {
  $rel = $file.FullName.Replace($signalHtmlDir, "").Replace("\", "/").TrimStart("/")
  $parts = $rel -split "/"
  $year = $parts[0]
  $month = $parts[1]
  $filename = $parts[-1]
  $id = $filename.Replace(".html", "")
  
  if (-not $archive.ContainsKey($year)) { $archive[$year] = @{} }
  if (-not $archive[$year].ContainsKey($month)) { $archive[$year][$month] = @{} }
  $archive[$year][$month][$id] = "$baseUrl/signals/$rel"
}

# ✅ بناء HTML بطريقة صحيحة
$indexHtml = @"
<!DOCTYPE html>
<html lang="$defaultLang">
<head>
  <meta charset="UTF-8">
  <title>PROTOCORE Signal Archive</title>
  <meta name="description" content="Multilingual signals organized by date">
  <link rel="stylesheet" href="assets/style.css">
</head>
<body>
  <h1>📡 Signal Archive</h1>
"@

foreach ($year in $archive.Keys | Sort-Object -Descending) {
  foreach ($month in $archive[$year].Keys | Sort-Object -Descending) {
    $indexHtml += "<h2>🗓️ $year/$month</h2><ul>`n"
    foreach ($id in $archive[$year][$month].Keys | Sort-Object -Descending) {
      $url = $archive[$year][$month][$id]
      $indexHtml += "  <li><a href='$url'>$id</a></li>`n"
    }
    $indexHtml += "</ul>`n"
  }
}

$indexHtml += "</body></html>"

# 💾 حفظ الصفحة
$indexPath = Join-Path $projectRoot "index.html"
$indexHtml | Out-File -Encoding UTF8 $indexPath
Write-Host "✅ أرشيف الإشارات جاهز: index.html"