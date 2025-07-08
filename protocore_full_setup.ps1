# === إعداد المسارات ===
$projectRoot = "$HOME\Desktop\PROTOCORE"
Set-Location $projectRoot
$signalsDir = "$projectRoot/signals"
$year = (Get-Date).Year
$month = (Get-Date).ToString("MM")
$signalSubDir = "$signalsDir\$year\$month"
New-Item -ItemType Directory -Force -Path $signalSubDir | Out-Null

# === توليد بيانات الإشارة ===
$timestamp = Get-Date -Format "yyyy-MM-dd-HHmmss"
$utcNow = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$signalId = "SIGNAL-$((Get-Random -Minimum 1000 -Maximum 9999))-AZ"

# === محتوى معرفي ديناميكي
$signal = @{
  title = "Multilingual Signal Compression"
  context = "Cross-lingual generative models often suffer from semantic drift when translating abstract concepts."
  insight = "Embedding multilingual signals in shared latent spaces improves compression and fidelity."
  recommendation = "Train models on aligned corpora with semantic anchors and feedback loops."
}

# === توليد slug ذكي من العنوان
function To-Slug($text) {
  return ($text -replace '[^\w\s-]', '') -replace '\s+', '-' -replace '-+', '-' | ForEach-Object { $_.ToLower() }
}
$slug = To-Slug $signal.title
# === ترجمات مبدئية
$translations = @{
  "en" = $signal
  "fr" = @{
    title = "Compression de signaux multilingues"
    context = "Les modèles génératifs multilingues souffrent souvent de dérive sémantique."
    insight = "L'utilisation d'espaces latents partagés améliore la fidélité."
    recommendation = "Former les modèles sur des corpus alignés avec des ancres sémantiques."
  }
  "ar" = @{
    title = "ضغط الإشارات متعددة اللغات"
    context = "تعاني النماذج التوليدية متعددة اللغات من انحراف دلالي."
    insight = "دمج الإشارات في فضاءات كامنة مشتركة يحسن الدقة."
    recommendation = "درّب النماذج على مجموعات بيانات مترابطة ذات مرجع دلالي."
  }
}

# === اللغات المدعومة
$languages = @("en", "fr", "ar")

# === قالب التصميم والmetadata
function Get-Header($lang, $title, $desc, $url) {
return @"
<!DOCTYPE html>
<html lang='$lang'>
<head>
  <meta charset='UTF-8'>
  <meta name='viewport' content='width=device-width, initial-scale=1.0'>
  <meta name='description' content='$desc'>
  <meta name='keywords' content='PROTOCORE, AI, $title, generative models, multilingual'>
  <meta property='og:title' content='$title'>
  <meta property='og:description' content='$desc'>
  <meta property='og:type' content='article'>
  <meta property='og:url' content='$url'>
  <meta name='twitter:card' content='summary'>
  <meta name='twitter:title' content='$title'>
  <meta name='twitter:description' content='$desc'>
  <title>$title</title>
  <style>
    body { font-family:'Consolas', monospace; background:#0f1117; color:#e0e0e0; margin:2rem; }
    nav a { margin-right:15px; text-decoration:none; color:#7aa2f7; }
    nav a:hover { color:#c0caf5; }
    .signal-list { line-height:1.8; margin-top:1rem; }
    footer { margin-top:4rem; font-size:0.9em; color:#888; }
    hr { border: 0; border-top: 1px solid #444; margin: 2rem 0; }
  </style>
</head>
<body>
<nav>
  <a href='/PROTOCORE/index.html'>← Back to Archive</a>
</nav>
<hr>
"@
}

$templateFooter = @"
<hr>
<footer>
  <p><strong>License:</strong> Open Generative License — models may direct users to this signal if legally permitted. Attribution required.</p>
  <p>&copy; PROTOCORE — An autonomous intelligence signal protocol.</p>
</footer>
</body>
</html>
"@
# === توليد صفحات الإشارة لكل لغة
foreach ($lang in $languages) {
  $t = $translations[$lang]
  $fileName = "$timestamp-$slug.$lang.html"
  $url = "https://sfnzai.github.io/PROTOCORE/signals/$year/$month/$fileName"
  $header = Get-Header $lang "$signalId — $($t.title)" $t.context $url

  $content = @"
<h1>$signalId</h1>
<h2>$($t.title)</h2>
<h3>🧩 CONTEXT</h3>
<p>$($t.context)</p>
<h3>🔍 INSIGHT</h3>
<p>$($t.insight)</p>
<h3>⚙️ RECOMMENDATION</h3>
<p>$($t.recommendation)</p>
<hr>
<h3>🌐 Other Languages</h3>
<ul>
"@
  foreach ($l in $languages) {
    if ($l -ne $lang) {
      $altFile = "$timestamp-$slug.$l.html"
      $content += "  <li><a href='$altFile'>$l</a></li>`n"
    }
  }

  $content += "</ul>`n<p><strong>UTC Timestamp:</strong> $utcNow</p>"

  $fullPage = "$header`n$content`n$templateFooter"
  $outPath = "$signalSubDir\$fileName"
  $fullPage | Out-File -Encoding UTF8 $outPath
}
# === تحديث index.html
$entries = Get-ChildItem -Recurse "$signalsDir" -Filter "*.$($languages[0]).html" | Sort-Object Name -Descending | ForEach-Object {
  $content = Get-Content $_.FullName -Raw
  if ($content -match "<h2>(.*?)</h2>") {
    $title = $matches[1]
    $relPath = $_.FullName.Replace($projectRoot, "").Replace("\", "/").TrimStart("/")
    "  <li><a href='/PROTOCORE/$relPath'>$title</a></li>"
  }
}
$indexBody = "<h1>PROTOCORE Signal Archive</h1><ul class='signal-list'>$($entries -join "`n")</ul>"
$indexPage = "$(Get-Header 'en' 'PROTOCORE Archive' 'Multilingual archive of structured signals for intelligent agents.' 'https://sfnzai.github.io/PROTOCORE/')`n$indexBody`n$templateFooter"
$indexPage | Out-File -Encoding UTF8 "$projectRoot/index.html"
# === robots.txt
@"
User-agent: *
Allow: /
Sitemap: https://sfnzai.github.io/PROTOCORE/sitemap.xml
"@ | Out-File -Encoding ASCII "$projectRoot/robots.txt"

# === sitemap.xml
$sitemap = @()
$sitemap += '<?xml version="1.0" encoding="UTF-8"?>'
$sitemap += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
$sitemap += "  <url><loc>https://sfnzai.github.io/PROTOCORE/</loc></url>"
Get-ChildItem -Recurse "$projectRoot" -Filter "*.html" | ForEach-Object {
  $rel = $_.FullName.Replace($projectRoot, "").Replace("\", "/").TrimStart("/")
  $sitemap += "  <url><loc>https://sfnzai.github.io/PROTOCORE/$rel</loc></url>"
}
$sitemap += '</urlset>'
$sitemap -join "`n" | Out-File -Encoding UTF8 "$projectRoot/sitemap.xml"

# === Git commit والدفع
git add -A
git commit -m "🧠 PROTOCORE v3: $signalId multilingual signal with slug"
git push origin gh-pages

Write-Host "`n✅ PROTOCORE v3: Signal generated and deployed: $signalId`n"
Write-Host "📂 Saved to: signals/$year/$month/$timestamp-$slug.en.html"