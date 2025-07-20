Set-Location "$PSScriptRoot\.."
. "$PSScriptRoot\..\config\globals.ps1"

$latestSignal = Get-ChildItem -Path $signalDataDir -Filter "*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $latestSignal) {
  Write-Host "⚠️ لا يوجد إشارات"
  return
}

$signal = Get-Content $latestSignal.FullName | ConvertFrom-Json
$signalId = "$($signal.id)"
$topic = "$($signal.topic)"
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
  <link rel="stylesheet" href="$baseUrl/assets/style.css" />
</head>
<body>
<nav>
  <a href="$baseUrl/index.html">🏠 Archive</a> |
  <a href="$baseUrl/about.html">📘 About</a> |
  <a href="$baseUrl/license.html">🛡 License</a> |
  <a href="$baseUrl/support.html">🤝 Support</a>
</nav>
<h1>$topic – Signal</h1>
<div class="lang-switcher">
  <label for="langSelect">🌐 Language:</label>
  <select id="langSelect">
"@

foreach ($lang in $languages) {
  $html += "    <option value='$lang'>$lang</option>`n"
}

$html += "</select></div>`n"

foreach ($lang in $languages) {
  if ($sections.$lang) {
    $s = $sections.$lang | ConvertTo-Json -Depth 2 | ConvertFrom-Json
    $context = "$($s.context)"
    $insight = "$($s.insight)"
    $recommendation = "$($s.recommendation)"
    $question = "$($s.question)"
    
    if ($lang -eq $defaultLang) {
      $display = "block"
    } else {
      $display = "none"
    }

    $html += @"
<article lang="$lang" class="signal-block" style="display:$display">
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
"@
  }
}

$html += @"
<script src="$baseUrl/assets/signal.js"></script>
<script>


window.addEventListener("DOMContentLoaded", () => {
  const select = document.getElementById("langSelect");
  const blocks = document.querySelectorAll(".signal-block");

  function updateLanguage(lang) {
    blocks.forEach(b => b.style.display = "none");
    const chosen = document.querySelector(`.signal-block[lang='${lang}']`);
    if (chosen) { chosen.style.display = "block"; }
  }

  select.addEventListener("change", function () {
    updateLanguage(this.value);
  });

  updateLanguage(select.value); // ← تفعل اللغة عند التحميل
});

</script>
<footer><p>License: OGL-1.0 – PROTOCORE Final</p></footer>
</body>
</html>
"@

$html | Out-File -Encoding UTF8 $outPath
Write-Host "✅ تم توليد صفحة الإشارة: $signalId.html"
Write-Host "📍 المسار: $outPath"