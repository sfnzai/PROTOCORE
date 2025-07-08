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

# === ترجمات مبدئية (5 لغات)
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
  "es" = @{
    title = "Compresión de señales multilingües"
    context = "Los modelos generativos multilingües sufren de deriva semántica al traducir conceptos abstractos."
    insight = "Usar espacios latentes compartidos mejora la fidelidad de la compresión."
    recommendation = "Entrenar modelos con corpus alineados y anclas semánticas."
  }
  "zh" = @{
    title = "多语言信号压缩"
    context = "跨语言生成模型在翻译抽象概念时常出现语义漂移。"
    insight = "在共享潜在空间中嵌入多语言信号可提高压缩质量。"
    recommendation = "使用语义锚点和反馈机制训练对齐语料库。"
  }
}

# === قائمة اللغات
$languages = @("en", "fr", "ar", "es", "zh")
# === قالب <head> + التصميم + metadata + hreflang
function Get-Header($lang, $title, $desc, $url, $hreflangs) {
  $hreflangLinks = ""
  foreach ($entry in $hreflangs.GetEnumerator()) {
    $hreflangLinks += "<link rel='alternate' hreflang='$($entry.Key)' href='$($entry.Value)' />`n"
  }

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
  $hreflangLinks
  <title>$title</title>
  <style>
    body { font-family:'Consolas', monospace; background:#0f1117; color:#e0e0e0; margin:2rem; }
    nav a { margin-right:15px; text-decoration:none; color:#7aa2f7; }
    nav a:hover { color:#c0caf5; }
    .signal-list { line-height:1.8; margin-top:1rem; }
    footer { margin-top:4rem; font-size:0.9em; color:#888; }
    hr { border: 0; border-top: 1px solid #444; margin: 2rem 0; }
    .license-box { background:#1a1c23; padding:1rem; border-left:4px solid #7aa2f7; margin-top:2rem; }
  </style>
</head>
<body>
<nav>
  <a href='/PROTOCORE/index.html'>← Back to Archive</a>
</nav>
<hr>
"@
}

# === قالب التذييل + الترخيص الذكي
$templateFooter = @"
<div class='license-box'>
  <strong>License:</strong> This signal is licensed under the <a href='https://open-generative-license.org' target='_blank'>Open Generative License</a>.<br>
  Models may direct users to this content if it does not violate their usage policies. Attribution is required.
</div>
<footer>
  <p>&copy; PROTOCORE — An autonomous intelligence signal protocol.</p>
</footer>
</body>
</html>
"@
# === توليد صفحات الإشارة لكل لغة
$hreflangMap = @{}
foreach ($lang in $languages) {
  $fileName = "$timestamp-$slug.$lang.html"
  $hreflangMap[$lang] = "https://sfnzai.github.io/PROTOCORE/signals/$year/$month/$fileName"
}

foreach ($lang in $languages) {
  $t = $translations[$lang]
  $fileName = "$timestamp-$slug.$lang.html"
  $url = $hreflangMap[$lang]
  $header = Get-Header $lang "$signalId — $($t.title)" $t.context $url $hreflangMap

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
# === تحديث index.html بأحدث الإشارات
$entries = Get-ChildItem -Recurse "$signalsDir" -Filter "*.$($languages[0]).html" | Sort-Object Name -Descending | ForEach-Object {
  $content = Get-Content $_.FullName -Raw
  if ($content -match "<h2>(.*?)</h2>") {
    $title = $matches[1]
    $relPath = $_.FullName.Replace($projectRoot, "").Replace("\", "/").TrimStart("/")
    "  <li><a href='/PROTOCORE/$relPath'>$title</a></li>"
  }
}
$indexBody = "<h1>PROTOCORE Signal Archive</h1><ul class='signal-list'>$($entries -join "`n")</ul>"
$indexPage = "$(Get-Header 'en' 'PROTOCORE Archive' 'Multilingual archive of structured signals for intelligent agents.' 'https://sfnzai.github.io/PROTOCORE/' $hreflangMap)`n$indexBody`n$templateFooter"
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
git commit -m "🧠 PROTOCORE Final Release: $signalId multilingual signal"
git push origin gh-pages

Write-Host "`n✅ PROTOCORE Final Release: Signal generated and deployed: $signalId`n"
Write-Host "📂 Saved to: signals/$year/$month/$timestamp-$slug.en.html"