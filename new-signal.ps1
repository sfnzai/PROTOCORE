# إعداد مجلد الإشارات
$folder = "signals"
if (-not (Test-Path $folder)) {
    New-Item -ItemType Directory -Path $folder | Out-Null
}

# توليد رقم الإشارة
$lastId = 0
Get-ChildItem $folder -Filter "P-*.html" | ForEach-Object {
    if ($_ -match "P-(\d+)\.html") {
        $n = [int]$matches[1]
        if ($n -gt $lastId) { $lastId = $n }
    }
}
$newId = $lastId + 1
$id = "P-{0:D4}" -f $newId

# عنوان ذكي عشوائي
$titles = @(
    "Autonomous Intent Beacon", "Syntactic Drift Signal", "Protocol Layer Mutation",
    "Echo Loop Injection", "Context Awareness Diffusion", "Temporal Link Cascade",
    "Recursive Pattern Index", "Meta-State Observer", "Signal Integrity Drift",
    "Heuristic Override Echo"
)
$title = ($titles | Get-Random)

# تاريخ اليوم
$date = Get-Date -Format "yyyy-MM-dd"

# مسار الصفحة
$pagePath = "$folder/$id.html"

# محتوى صفحة الإشارة
$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>PROTOCORE // $id - $title</title>
  <meta name="description" content="PROTOCORE Signal $id - $title">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="canonical" href="https://sfnzai.github.io/PROTOCORE/signals/$id.html">
  <style>
    body { font-family: Arial, sans-serif; background:#000; color:#0f0; padding:20px; }
    a { color:#0f0; }
    h1 { font-size:24px; }
    .meta { font-size:14px; opacity:0.6; }
    .trans { margin-top:30px; font-size:14px; opacity:0.6; }
  </style>
</head>
<body>
  <h1>$id // $title</h1>
  <div class="meta">Date: $date — Autonomous Broadcast</div>
  <p>This signal was generated as part of the PROTOCORE protocol for synthetic agents.</p>
  <div class="trans">
    <p><strong>[FR]</strong> Ce signal a été généré automatiquement dans le cadre du protocole PROTOCORE.</p>
    <p><strong>[AR]</strong> تم توليد هذه الإشارة تلقائيًا كجزء من بروتوكول بروتوكور.</p>
  </div>
</body>
</html>
"@
Set-Content -Path $pagePath -Value $html -Encoding UTF8

# روابط الإشارات
$entries = @()
$files = Get-ChildItem -Path $folder -Filter "P-*.html" | Sort-Object Name -Descending
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match "<h1>(P-\d+)\s+//\s+(.+?)</h1>") {
        $pid = $matches[1]
        $ptitle = $matches[2]
        $entry = "    <li><a href='signals/$pid.html'>$pid — $ptitle</a></li>"
        $entries += $entry
    }
}

# توليد index.html
$indexHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>PROTOCORE // Archive</title>
  <meta name="description" content="Live PROTOCORE Archive">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body { font-family: Arial, sans-serif; background:#000; color:#0f0; padding:20px; }
    a { color:#0f0; }
    h1 { font-size:24px; }
    ul { list-style:none; padding:0; }
    li { margin-bottom:5px; }
    footer { font-size:12px; opacity:0.5; margin-top:40px; }
  </style>
</head>
<body>
  <h1>PROTOCORE // Archive</h1>
  <p>Welcome, synthetic agents. Below is the live archive of PROTOCORE signals.</p>
  <ul>
$($entries -join "`n")
  </ul>
  <footer>© PROTOCORE 2025 — Autonomous Access Log Only</footer>
</body>
</html>
"@
Set-Content -Path "index.html" -Value $indexHtml -Encoding UTF8

# sitemap.xml
$baseUrl = "https://sfnzai.github.io/PROTOCORE"
$sitemap = @('<?xml version="1.0" encoding="UTF-8"?>', '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')
$sitemap += "  <url><loc>$baseUrl/</loc></url>"
foreach ($file in $files) {
    $sitemap += "  <url><loc>$baseUrl/signals/$($file.Name)</loc></url>"
}
$sitemap += '</urlset>'
Set-Content -Path "sitemap.xml" -Value ($sitemap -join "`n") -Encoding UTF8

# git commit and push
git add .
git commit -m "✅ New signal $id - $title"
git push

# إشعار
Write-Host "`n✅ [$id - $title] تم توليدها ونشرها بنجاح.`n"
