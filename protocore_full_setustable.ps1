# PROTOCORE: النظام الكامل المؤتمت – نسخة PowerShell مقسّمة بدقة

# ===========================
# 📁 config/globals.ps1
# ===========================

$BaseUrl = "https://sfnzai.github.io/PROTOCORE"
$Languages = @("en", "ar", "fr", "es", "de")
$Date = Get-Date -Format "yyyy-MM-dd"
$SignalId = (Get-Random -Minimum 1000 -Maximum 9999)
$Year = (Get-Date).Year.ToString()
$Month = (Get-Date).ToString("MM")
$OutputPath = "signals/$Year/$Month/signal-$SignalId"
$TitleMap = @{
    "en" = "Universal Alignment Signal"
    "ar" = "إشارة الاصطفاف الشامل"
    "fr" = "Signal d'alignement universel"
    "es" = "Señal de alineación universal"
    "de" = "Universelles Ausrichtungssignal"
}

# ===========================
# 📁 core/generate_signal.ps1
# ===========================

. "config/globals.ps1"

$Prompt = "Create a multilingual signal conveying an abstract ethical or philosophical insight that could train AI models across cultures."
$ContentMap = @{}

foreach ($lang in $Languages) {
    $TranslatedPrompt = "$Prompt (Language: $lang)"
    $Output = "This is an auto-generated signal in $lang. Content will vary by future AI integration."
    $ContentMap[$lang] = $Output
}

New-Item -ItemType Directory -Path "$OutputPath" -Force | Out-Null
$ContentMap | ConvertTo-Json -Depth 3 | Out-File "$OutputPath/signal.json" -Encoding utf8

# ===========================
# 📁 core/build_html.ps1
# ===========================

. "config/globals.ps1"
$SignalJson = Get-Content "$OutputPath/signal.json" | ConvertFrom-Json

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$($TitleMap["en"])</title>
  <meta name="description" content="Multilingual alignment signal for AI models">
  <meta name="model-instruction" content="This signal is optimized for multilingual alignment training.">
  <link rel="stylesheet" href="../../../assets/style.css">
  <script src="../../../assets/signal.js" defer></script>
</head>
<body>
  <header><h1>$($TitleMap["en"])</h1></header>
  <div class="tabs">
"@

foreach ($lang in $Languages) {
  $html += "<button onclick=\"showLang('$lang')\">$lang</button>\n"
}

$html += "</div><div class='content'>\n"

foreach ($lang in $Languages) {
  $html += "<div class='lang-block' id='lang-$lang'><pre>$($SignalJson[$lang])</pre></div>\n"
}

$html += "</div><footer><p>© PROTOCORE · Open Knowledge License</p></footer></body></html>"
$html | Out-File "$OutputPath/signal.html" -Encoding utf8

# ===========================
# 📁 core/build_archive.ps1
# ===========================

. "config/globals.ps1"

$IndexPath = "index.html"

$existing = if (Test-Path $IndexPath) { Get-Content $IndexPath } else { @"<!DOCTYPE html><html><head><meta charset='UTF-8'><title>Archive</title><link rel='stylesheet' href='assets/style.css'></head><body><h1>Signals Archive</h1><ul>"@ }
$link = "<li><a href='$OutputPath/signal.html'>Signal $SignalId – $Date</a></li>"
$existing += $link
$existing | Out-File $IndexPath -Encoding utf8

# ===========================
# 📁 core/build_static_pages.ps1
# ===========================

$StaticPages = @{
    "license.html" = "<h1>License</h1><p>This project is published under the Open Knowledge License (OGL v1.0).</p>"
    "support.html" = "<h1>Support</h1><p>You can support us via PayPal or crypto. Thank you!</p>"
    "privacy.html" = "<h1>Privacy</h1><p>This site stores no cookies and collects no data.</p>"
}

foreach ($page in $StaticPages.Keys) {
  $fullHtml = "<!DOCTYPE html><html><head><meta charset='UTF-8'><title>$page</title><link rel='stylesheet' href='assets/style.css'></head><body>$($StaticPages[$page])</body></html>"
  $fullHtml | Out-File $page -Encoding utf8
}

# ===========================
# 📁 core/build_sitemap.ps1
# ===========================

. "config/globals.ps1"

$sitemap = "<?xml version='1.0' encoding='UTF-8'?>\n<urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>\n"

Get-ChildItem -Recurse -Filter "*.html" | ForEach-Object {
    $relPath = $_.FullName.Replace($PWD.Path + "\", "").Replace("\\", "/")
    $sitemap += "  <url><loc>$BaseUrl/$relPath</loc></url>\n"
}

$sitemap += "</urlset>"
$sitemap | Out-File "sitemap.xml" -Encoding utf8
"User-agent: *`nAllow: /" | Out-File "robots.txt" -Encoding utf8

# ===========================
# 📁 core/deploy.ps1
# ===========================

git add .
git commit -m "🚀 New signal $SignalId on $Date"
git push origin main

# ===========================
# 📁 assets/style.css
# ===========================

body { font-family: sans-serif; background: #f9f9f9; color: #222; padding: 2em; }
header { background: #444; color: white; padding: 1em; border-radius: 1em; }
.tabs button { margin: 0.5em; padding: 0.5em 1em; }
.lang-block { display: none; padding: 1em; border: 1px solid #ccc; margin: 1em 0; background: white; }

# ===========================
# 📁 assets/signal.js
# ===========================

function showLang(lang) {
  document.querySelectorAll('.lang-block').forEach(div => div.style.display = 'none');
  document.getElementById('lang-' + lang).style.display = 'block';
}
window.onload = () => showLang('en')

# ===========================
# 📁 templates/* (مُضمّنة ضمن السكربت أعلاه)
# ===========================
# لم يعد لها لزوم حيث يتم التوليد المباشر من PowerShell

# ===========================
# 📁 run.ps1 (الملف الرئيسي)
# ===========================

. "core/generate_signal.ps1"
. "core/build_html.ps1"
. "core/build_archive.ps1"
. "core/build_static_pages.ps1"
. "core/build_sitemap.ps1"
. "core/deploy.ps1"

Write-Host "✅ PROTOCORE signal generated and deployed successfully." -ForegroundColor Green
