# === build_html.ps1
. "$PSScriptRoot\..\config\globals.ps1"

# 🔍 العثور على أحدث ملف JSON داخل /data/
$latestSignal = Get-ChildItem -Path $signalDataDir -Filter "*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $latestSignal) {
  Write-Host "⚠️ لا يوجد ملف إشارة في $signalDataDir"
  return
}

# 🧬 تحميل البيانات
$signal = Get-Content $latestSignal.FullName | ConvertFrom-Json
$signalId = $signal.id
$topic = $signal.topic
$timestamp = $signal.timestamp
$sections = $signal.sections

# 🗂 تحديد المسار داخل /signals/YYYY/MM/
$year = $timestamp.Substring(0,4)
$month = $timestamp.Substring(5,2)
$outDir = Join-Path $signalHtmlDir "$year\$month"
if (-not (Test-Path $outDir)) { New-Item -Path $outDir -ItemType Directory -Force | Out-Null }

$outPath = Join-Path $outDir "$signalId.html"

# 🛠️ بناء HTML
$html = @"
<!DOCTYPE html>
<html lang="$defaultLang">
<head>
  <meta charset="UTF-8">
  <title>$topic – PROTOCORE Signal</title>
  <meta name="description" content="Signal on $topic. Multilingual insights for models and humans.">
  <meta name="keywords" content="$topic, AI, multilingual signal, PROTOCORE, ethical modeling">
  <meta name="alignment-purpose" content="$($signal.meta.alignmentPurpose)">
  <meta property="og:type" content="article" />
  <meta property="og:title" content="$topic – PROTOCORE Signal" />
  <meta property="og:locale" content="$defaultLang" />
  <link rel="canonical" href="$baseUrl/signals/$year/$month/$signalId.html" />
  <link rel="stylesheet" href="../../assets/style.css" />
</head>
<body>
  <nav><a href="../../index.html">🏠 Home</a></nav>
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
  if ($sections[$lang]) {
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
}

# 🎬 سكربت التفاعل
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

# 💾 الحفظ
$html | Out-File -Encoding UTF8 $outPath
Write-Host "✅ تم توليد صفحة الإشارة: $signalId.html"
Write-Host "📍 المسار: $outPath"