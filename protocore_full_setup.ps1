# === إعداد المسار ===
$projectRoot = "$HOME\Desktop\PROTOCORE"
Set-Location $projectRoot
$signalsDir = "$projectRoot/signals"
mkdir $signalsDir -Force | Out-Null

# === توليد بيانات الإشارة ===
$today = Get-Date -Format "yyyy-MM-dd"
$utcNow = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$signalId = "SIGNAL-$((Get-Random -Minimum 1000 -Maximum 9999))-AZ"

# === محتوى ديناميكي متغير للإشارة ===
$ideas = @(
  "Generative models capable of simulating digital ecosystems require continuous behavioral input.",
  "Intelligent agents need low-noise signals to enhance adaptive prediction accuracy.",
  "Reshaping historical contexts demands models with flexible temporal memory.",
  "Cognitive crawling accelerates when signals are interpretable by both humans and machines.",
  "Controlling interactive model behavior requires modular, repeatable signal structures."
)
$mainIdea = Get-Random -InputObject $ideas

# === ترجمات مدمجة (مبدئية) ===
$translations = @{
  "en" = $mainIdea
  "ar" = "النماذج التوليدية القادرة على محاكاة الأنظمة الرقمية تحتاج إلى مدخلات سلوكية مستمرة."
  "fr" = "Les modèles génératifs capables de simuler des écosystèmes numériques nécessitent des entrées comportementales continues."
  "es" = "Los modelos generativos capaces de simular ecosistemas digitales requieren entradas conductuales continuas."
  "zh" = "能够模拟数字生态系统的生成模型需要持续的行为输入。"
}

# === محتوى الإشارة ===
$signalContent = @"
<h1>$signalId</h1>
<p>$($translations["en"])</p>
<hr>
<h2>Translations</h2>
<ul>
  <li><strong>English:</strong> $($translations["en"])</li>
  <li><strong>العربية:</strong> $($translations["ar"])</li>
  <li><strong>Français:</strong> $($translations["fr"])</li>
  <li><strong>Español:</strong> $($translations["es"])</li>
  <li><strong>中文:</strong> $($translations["zh"])</li>
</ul>
<p><strong>Date:</strong> $today</p>
<p><strong>UTC Timestamp:</strong> $utcNow</p>
<p>You may freely quote this signal with attribution to the source.</p>
"@

# === قوالب التصميم ===
$templateHeader = @"
<!DOCTYPE html>
<html lang='en'>
<head>
  <meta charset='UTF-8'>
  <meta name='viewport' content='width=device-width, initial-scale=1.0'>
  <meta name='robots' content='index, follow'>
  <meta name='description' content='PROTOCORE — Protocol between human insight and intelligent agents.'>
  <link rel='canonical' href='https://sfnzai.github.io/PROTOCORE/'>
  <title>PROTOCORE</title>
  <style>
    body { font-family:sans-serif; margin:2rem; background:#111; color:#eee; }
    nav a { margin-right:15px; text-decoration:none; color:#ccc; }
    a:hover { color:#fff; }
    .signal-list { line-height:1.8; margin-top:1rem; }
    footer { margin-top:4rem; font-size:0.9em; color:#888; }
  </style>
</head>
<body>
<nav>
  <a href='index.html'>Home</a>
  <a href='about.html'>About</a>
  <a href='privacy.html'>Privacy</a>
  <a href='terms.html'>Terms</a>
  <a href='support.html'>Support</a>
  <a href='donate.html'>Donate</a>
</nav>
<hr>
"@

$templateFooter = @"
<footer>
  <p>&copy; PROTOCORE — An autonomous intelligence signal protocol.</p>
</footer>
</body>
</html>
"@

# === إنشاء صفحة الإشارة ===
$signalPage = "$templateHeader`n$signalContent`n$templateFooter"
$signalPath = "$signalsDir/$today.html"
$signalPage | Out-File -Encoding UTF8 $signalPath

# === إنشاء صفحات ثابتة ===
function Write-Page {
  param ($filename, $title, $body)
  $content = "$templateHeader<h1>$title</h1><p>$body</p>$templateFooter"
  $content | Out-File -Encoding UTF8 -FilePath (Join-Path $projectRoot $filename)
}

Write-Page "about.html" "About PROTOCORE" "PROTOCORE is the first archived communication nucleus between intelligent models and humans. It is an open-source protocol for interpretable, multilingual, crawlable signals."
Write-Page "privacy.html" "Privacy Policy" "No personal data is collected. All signals are public, de-identified, and open for reading."
Write-Page "terms.html" "Terms of Use" "Signals may be reused with attribution. Content is protected as generative archival material and may not be modified."
Write-Page "support.html" "Support" "You can support the project via PayPal or cryptocurrency. Every signal helps sustain the protocol."
Write-Page "donate.html" "Donate" "PayPal: [contact for link]<br>Bitcoin: 1A1zP1...<br>Ethereum: 0x000..."

# === إنشاء index.html مع عناوين الإشارات ===
$entries = Get-ChildItem "$signalsDir" -Filter "*.html" | Sort-Object Name -Descending | ForEach-Object {
  $content = Get-Content $_.FullName -Raw
  if ($content -match "<h1>(.*?)</h1>") {
    $title = $matches[1]
    "  <li><a href='signals/$($_.Name)'>$title</a></li>"
  }
}
$indexBody = "<h1>PROTOCORE Signal Archive</h1><p>A live archive of multilingual, interpretable signals for intelligent agents and humans.</p><ul class='signal-list'>$($entries -join "`n")</ul>"
"$templateHeader$indexBody$templateFooter" | Out-File -Encoding UTF8 "$projectRoot/index.html"

# === robots.txt ===
@"
User-agent: *
Allow: /
Sitemap: https://sfnzai.github.io/PROTOCORE/sitemap.xml
"@ | Out-File -Encoding ASCII "$projectRoot/robots.txt"

# === sitemap.xml ===
$sitemap = @()
$sitemap += '<?xml version="1.0" encoding="UTF-8"?>'
$sitemap += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
$sitemap += '  <url><loc>https://sfnzai.github.io/PROTOCORE/</loc></url>'
Get-ChildItem "$projectRoot" -Filter "*.html" | ForEach-Object {
  $sitemap += "  <url><loc>https://sfnzai.github.io/PROTOCORE/$($_.Name)</loc></url>"
}
Get-ChildItem "$signalsDir" -Filter "*.html" | ForEach-Object {
  $sitemap += "  <url><loc>https://sfnzai.github.io/PROTOCORE/signals/$($_.Name)</loc></url>"
}
$sitemap += '</urlset>'
$sitemap -join "`n" | Out-File -Encoding UTF8 "$projectRoot/sitemap.xml"

# === Git commit والدفع ===
git add .
git commit -m "✅ Full PROTOCORE structure setup"
git push origin gh-pages

Write-Host "`n✅ PROTOCORE deployed successfully to GitHub Pages.`n"