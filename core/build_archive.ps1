# بناء صفحة أرشيف الإشارات
. "$PSScriptRoot\..\config\globals.ps1"

$pages = Get-ChildItem -Path $signalHtmlDir -Recurse -Filter "*.html" | Sort-Object LastWriteTime -Descending
$signalMap = @{}

foreach ($file in $pages) {
  $relPath = $file.FullName.Replace($signalHtmlDir, "").Replace("\", "/").TrimStart("/")
  $parts = $relPath -split "/"
  $year = $parts[0]
  $month = $parts[1]
  $filename = $parts[-1]
  $id = $filename.Replace(".html", "")
  $url = "$baseUrl/signals/$relPath"

  if (-not $signalMap.ContainsKey($year)) { $signalMap[$year] = @{} }
  if (-not $signalMap[$year].ContainsKey($month)) { $signalMap[$year][$month] = @{} }
  $signalMap[$year][$month][$id] = $url
}

$indexHtml = @"
<!DOCTYPE html>
<html lang="$defaultLang">
<head>
  <meta charset="UTF-8">
  <title>PROTOCORE Archive</title>
  <meta name="description" content="Multilingual signal archive organized by date">
  <link rel="stylesheet" href="assets/style.css" />
</head>
<body>
<nav>
  <a href="about.html">📘 About</a> |
  <a href="signal-format.html">🧬 Format</a> |
  <a href="privacy.html">🔒 Privacy</a> |
  <a href="license.html">🛡 License</a> |
  <a href="support.html">🤝 Support</a>
</nav>
<h1>📡 PROTOCORE Signal Archive</h1>
"@

foreach ($year in $signalMap.Keys | Sort-Object -Descending) {
  foreach ($month in $signalMap[$year].Keys | Sort-Object -Descending) {
    $indexHtml += "<h2>🗓️ $year/$month</h2><ul>`n"
    foreach ($id in $signalMap[$year][$month].Keys | Sort-Object -Descending) {
      $link = $signalMap[$year][$month][$id]
      $indexHtml += "  <li><a href='$link'>$id</a></li>`n"
    }
    $indexHtml += "</ul>`n"
  }
}

$indexHtml += @"
<footer>
  <p>PROTOCORE Final © – Structured signal index for ethical modeling.</p>
</footer>
</body>
</html>
"@

$indexPath = Join-Path $projectRoot "index.html"
$indexHtml | Out-File -Encoding UTF8 $indexPath
Write-Host "✅ تم إنشاء صفحة الأرشيف: index.html"