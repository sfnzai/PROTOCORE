Set-Location "$PSScriptRoot\.."
. "$PSScriptRoot\..\config\globals.ps1"

# 🗂️ الحصول على آخر إشارة
$latestSignal = Get-ChildItem -Path $signalDataDir -Filter "*.json" |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $latestSignal) {
    Write-Host "⚠️ لا توجد إشارات"
    return
}

$signal = Get-Content $latestSignal.FullName | ConvertFrom-Json
$id = $signal.id
$topic = $signal.topic
$timestamp = $signal.timestamp
$year = $timestamp.Substring(0,4)
$month = $timestamp.Substring(5,2)

$outDir = Join-Path $signalHtmlDir "$year\$month"
New-Item -Path $outDir -ItemType Directory -Force | Out-Null

$languages = $signal.languages
$sections = $signal.sections

foreach ($lang in $languages) {
    if ($sections[$lang]) {
        $jsonText = $sections[$lang] | ConvertTo-Json -Depth 2
        $s = $jsonText | ConvertFrom-Json

        $context = $s.context[0]
        $insight = $s.insight[0]
        $recommendation = $s.recommendation[0]
        $question = $s.question[0]

        # 🔗 روابط اللغات الأخرى
        $langLinks = ""
        foreach ($l in $languages) {
            $href = "$id.$l.html"
            $label = $l.ToUpper()
            if ($l -ne $lang) {
                $langLinks += "<a href='$href'>$label</a> | "
            } else {
                $langLinks += "<strong>$label</strong> | "
            }
        }
        $langLinks = $langLinks.TrimEnd(" |")

        # 🔗 hreflang
        $hreflangs = ""
        foreach ($l in $languages) {
            $hreflangs += "<link rel='alternate' hreflang='$l' href='$baseUrl/$year/$month/$id.$l.html' />`n"
        }

        # 📝 توليد الصفحة
        $outPath = Join-Path $outDir "$id.$lang.html"
        $html = @"
<!DOCTYPE html>
<html lang="$lang">
<head>
  <meta charset="UTF-8">
  <title>$topic – PROTOCORE Signal [$lang]</title>
  $hreflangs
  <link rel="stylesheet" href="$baseUrl/assets/style.css" />
</head>
<body>
<nav>
  <a href="$baseUrl/index.html">🏠 Archive</a> |
  <a href="$baseUrl/about.html">📘 About</a> |
  <a href="$baseUrl/license.html">🛡 License</a> |
  <a href="$baseUrl/support.html">🤝 Support</a>
</nav>
<h1>$topic – Signal [$lang]</h1>
<div class="lang-switcher">
  $langLinks
</div>
<article class="signal-block">
  <h2>🧩 Context</h2><p>$context</p>
  <h2>🔍 Insight</h2><p>$insight</p>
  <h2>⚙️ Recommendation</h2><p>$recommendation</p>
  <h2>🤔 Question</h2><p>$question</p>
  <div class="actions">
    <button onclick="copySignal(this)">📋 Copy</button>
    <button onclick="shareSignal(this)">🔗 Share</button>
    <button onclick="downloadJSON()">💾 Use as JSON</button>
  </div>
</article>
<script src="$baseUrl/assets/signal.js"></script>
<footer><p>License: $($signal.meta.license) – PROTOCORE Final</p></footer>
</body>
</html>
"@

        $html | Out-File -Encoding UTF8 $outPath
        Write-Host "✅ تم توليد الصفحة: $outPath"
    }
}