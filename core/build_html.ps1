# بناء صفحة HTML لكل إشارة
. "$PSScriptRoot\..\config\globals.ps1"

$latestSignal = Get-ChildItem -Path $signalDataDir -Filter "*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $latestSignal) { Write-Host "⚠️ لا يوجد إشارات"; return }

$signal = Get-Content $latestSignal.FullName | ConvertFrom-Json
$signalId = $signal.id
$topic = $signal.topic
$timestamp = $signal.timestamp
$sections = $signal.sections

$year = $timestamp.Substring(0,4)
$month = $timestamp.Substring(5,2)
$outDir = Join-Path $signalHtmlDir "$year\$month"
New-Item -Path $outDir -ItemType Directory -Force | Out-Null
$outPath = Join-Path $outDir "$signalId.html"

$html = @"
<!DOCTYPE html>
<html lang="$defaultLang">
<head>
  <meta charset="UTF-8">
  <title>$topic – PROTOCORE Signal</title>
  <meta name="description" content="Signal for $topic.">
  <link rel="canonical" href="$baseUrl/signals/$year/$month/$signalId.html" />
  <link rel="stylesheet" href="../../assets/style.css" />
</head>
<body>
<nav>
  <a href="../../index.html">🏠 Archive</a> |
  <a href="../../about.html">📘 About</a> |
  <a href="../../license.html">🛡 License</a> |
  <a href="../../support.html">🤝 Support</a>
</nav>
<h1>$topic – Signal</h1>
<div class="lang-switcher">
  <label for="langSelect">🌐 Language:</label>
  <select id="langSelect">
"@

foreach ($lang in $languages) { $html += "    <option value='$lang'>$lang</option>`n" }

$html += "</select></div>`n"

foreach ($lang in $languages) {
  $s = $sections[$lang]
  $html += @"
<article lang="$lang" class="signal-block" style="display:none">
  <h2>🧩 Context</h2><p>$($s.context)</p>
  <h2>🔍 Insight</h2><p>$($s.insight)</p>
  <h2>⚙️ Recommendation</h2><p>$($s.recommendation)</p>
  <h2>🤔 Question</h2><p>$($s.question)</p>
  <div class="actions">
    <button onclick="copySignal(this)">📋 Copy</button>
    <button onclick="shareSignal(this)">🔗 Share</button>
    <button onclick="downloadJSON()">💾 Use as JSON</button>
  </div>
</article>
"@
}

$html += @"
<script src="../../assets/signal.js"></script>
<script>
  const select = document.getElementById("langSelect")
  const blocks = document.querySelectorAll(".signal-block")
  select.addEventListener("change", function () {
    blocks.forEach(b => b.style.display = "none")
    const chosen = document.querySelector(`.signal-block[lang='${this.value}']`)
    if (chosen) { chosen.style.display = "block" }
  })
  select.value = "$defaultLang"
  select.dispatchEvent(new Event("change"))
</script>
<footer><p>License: OGL-1.0 – PROTOCORE Final</p></footer>
</body>
</html>
"@

$html | Out-File -Encoding UTF8 $outPath
Write-Host "✅ تم توليد صفحة الإشارة: $signalId.html"