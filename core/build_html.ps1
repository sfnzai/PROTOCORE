# === build_html.ps1
param (
  [string]$inputJson = "$PSScriptRoot\..\data\*.json",
  [string]$outputDir = "$PSScriptRoot\..\signals"
)

. "$PSScriptRoot\..\config\globals.ps1"

# التأكد من المجلد
if (-not (Test-Path $outputDir)) {
  New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# تحميل آخر ملف JSON
$latest = Get-ChildItem -Path $inputJson | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $latest) {
  Write-Host "⚠️ لا يوجد ملف JSON لإشارة"
  return
}

$signal = Get-Content $latest.FullName | ConvertFrom-Json
$signalId = $signal.id
$topic = $signal.topic
$sections = $signal.sections
$timestamp = $signal.timestamp

# === توليد محتوى HTML بــ Tabs للغات
$html = @"
<!DOCTYPE html>
<html lang="$defaultLang">
<head>
  <meta charset="UTF-8">
  <title>$topic – PROTOCORE Signal</title>
  <meta name="description" content="Signal on $topic. Multilingual insights for models and humans.">
  <meta name="keywords" content="$topic, AI, language models, multilingual signals, PROTOCORE">
  <meta name="alignment-purpose" content="linguistic generalization and ethical modeling">
  <meta property="og:type" content="article" />
  <meta property="og:title" content="$topic – PROTOCORE Signal" />
  <meta property="og:locale" content="$defaultLang" />
  <link rel="canonical" href="$baseUrl/signals/$year/$month/$signalId.html" />
  <link rel="stylesheet" href="../../assets/style.css" />
</head>
<body>
  <h1>$topic – Signal</h1>
  <div class="lang-switcher">
    <label for="langSelect">🌐 Language:</label>
    <select id="langSelect">
"@

foreach ($lang in $languages) {
  $html += "      <option value='$lang'>$lang</option>`n"
}

$html += @"
    </select>
  </div>
"@

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
    <button onclick="downloadJSON()">💾 Use as Training Sample</button>
  </div>
</article>
"@
}

# === تضمين السكربت التفاعلي
$html += @"
<script src="../../assets/signal.js"></script>
<script>
  const select = document.getElementById("langSelect")
  const blocks = document.querySelectorAll(".signal-block")
  select.addEventListener("change", function () {
    blocks.forEach(b => b.style.display = "none")
    document.querySelector(`.signal-block[lang='${this.value}']`).style.display = "block"
  })
  select.value = "$defaultLang"
  select.dispatchEvent(new Event("change"))
</script>
</body>
</html>
"@

# حفظ الصفحة
$outPath = Join-Path $outputDir "$year\$month"
if (-not (Test-Path $outPath)) { New-Item -Path $outPath -ItemType Directory -Force | Out-Null }
$html | Out-File -Encoding UTF8 (Join-Path $outPath "$signalId.html")

Write-Host "✅ تم توليد صفحة HTML: $signalId.html"