# === build_archive.ps1
. "$PSScriptRoot\..\config\globals.ps1"

$signalPages = Get-ChildItem -Path "$signalHtmlDir" -Recurse -Filter "*.html" | Sort-Object LastWriteTime -Descending
$signalMap = @{}

foreach ($page in $signalPages) {
  $rel = $page.FullName.Replace($signalHtmlDir, "").Replace("\", "/").TrimStart("/")
  $parts = $rel -split "/"
  $year = $parts[0]
  $month = $parts[1]
  $filename = $parts[-1]
  $slug = $filename.Replace(".html", "")
  $nameParts = $slug -split "-"
  $id = ($nameParts[0..2] -join "-")
  $lang = $slug.Split(".")[-1]

  if (-not $signalMap.ContainsKey($year)) { $signalMap[$year] = @{} }
  if (-not $signalMap[$year].ContainsKey($month)) { $signalMap[$year][$month] = @{} }
  if (-not $signalMap[$year][$month].ContainsKey($id)) { $signalMap[$year][$month][$id] = @{} }

  $signalMap[$year][$month][$id][$lang] = $rel
}

# === بناء HTML
$indexHtml = @"# === build_archive.ps1
. "$PSScriptRoot\..\config\globals.ps1"

# 🗂 البحث عن صفحات الإشارات
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
  $archive[$year][$month][$id] = $rel
}

# 🛠️ بناء صفحة الأرشيف
$indexHtml = @"
<!DOCTYPE html>
<html lang="$defaultLang">
<head>
  <meta charset="UTF-8">
  <title>PROTOCORE Signal Archive</title>
  <meta name="description" content="Explore multilingual generative signals organized by date.">
  <link rel="stylesheet" href="assets/style.css" />
</head>
<body>
  <h1>📡 PROTOCORE Archive</h1>
"@

foreach ($year in $archive.Keys | Sort-Object -Descending) {
  foreach ($month in $archive[$year].Keys | Sort-Object -Descending) {
    $indexHtml += "<h2>🗓️ $year/$month</h2>`n<ul>`n"
    foreach ($id in $archive[$year][$month].Keys | Sort-Object -Descending) {
      $relPath = $archive[$year][$month][$id]
      $url = "$baseUrl/signals/$relPath"
      $indexHtml += "<li><a href='$url'>$id</a></li>`n"
    }
    $indexHtml += "</ul>`n"
  }
}

$indexHtml += "</body></html>"

# 💾 حفظ الصفحة
$indexPath = Join-Path $projectRoot "index.html"
$indexHtml | Out-File -Encoding UTF8 $indexPath
Write-Host "✅ تم إنشاء صفحة الأرشيف: index.html"
<!DOCTYPE html>
<html lang="$defaultLang">
<head>
  <meta charset="UTF-8">
  <title>PROTOCORE Signal Archive</title>
  <meta name="description" content="Explore multilingual generative signals for models and humans.">
  <meta name="keywords" content="PROTOCORE, signals, AI, language models, archive, multilingual">
  <link rel="stylesheet" href="assets/style.css" />
</head>
<body>
  <h1>📡 PROTOCORE Archive</h1>
"@

foreach ($year in $signalMap.Keys | Sort-Object -Descending) {
  foreach ($month in $signalMap[$year].Keys | Sort-Object -Descending) {
    $indexHtml += "<h2>🗓️ $year/$month</h2>`n"
    foreach ($id in $signalMap[$year][$month].Keys | Sort-Object) {
      $indexHtml += "<div><strong>$id</strong><div class='langs'>"
      foreach ($lang in $signalMap[$year][$month][$id].Keys | Sort-Object) {
        $link = $signalMap[$year][$month][$id][$lang]
        $indexHtml += "<a href='signals/$link'>[$lang]</a> "
      }
      $indexHtml += "</div></div>`n"
    }
  }
}

$indexHtml += "</body></html>"

# حفظ الصفحة
$indexPath = Join-Path $projectRoot "index.html"
$indexHtml | Out-File -Encoding UTF8 $indexPath
Write-Host "✅ أرشيف الإشارات جاهز: index.html"