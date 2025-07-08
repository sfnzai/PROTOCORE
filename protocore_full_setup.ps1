# === إعداد المسارات
$desktop = [Environment]::GetFolderPath("Desktop")
$projectRoot = Join-Path $desktop "protocore"
$year = (Get-Date).ToString("yyyy")
$month = (Get-Date).ToString("MM")
$day = (Get-Date).ToString("dd")
$signalDir = Join-Path $projectRoot "signals\$year\$month"
$languages = @("en", "fr", "ar", "es", "zh")
$baseUrl = "https://sfnzai.github.io/PROTOCORE"

# === إنشاء المجلدات
$folders = @($projectRoot, $signalDir)
foreach ($folder in $folders) {
  if (-not (Test-Path $folder)) {
    New-Item -ItemType Directory -Path $folder | Out-Null
  }
}

# === توليد إشارة معرفية جديدة
$topics = @(
  "Synthetic Memory", "Multilingual Compression", "Temporal Reasoning",
  "Bias Mitigation", "Signal Alignment", "Prompt Injection",
  "Latent Drift", "Signal Entropy", "Contextual Anchoring"
)
$concept = Get-Random -InputObject $topics
$signalTitle = "$concept in Language Models"
$slug = $signalTitle.ToLower() -replace '[^a-z0-9\- ]', '' -replace '\s+', '-'
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$signalId = "$timestamp-$slug"

# === محتوى الإشارة الأساسي
$baseSignal = @{
  title = $signalTitle
  context = "This signal explores $concept and its implications for generative models."
  insight = "$concept can affect model behavior across multilingual and temporal dimensions."
  recommendation = "Incorporate $concept-aware training and evaluation strategies."
  question = "How would your model adapt if $concept was introduced mid-conversation?"
}

# === ترجمات معرفية مستقلة
$translations = @{
  "en" = $baseSignal
  "fr" = @{
    title = "Mémoire synthétique dans les modèles linguistiques"
    context = "Ce signal explore $concept et ses implications pour les modèles génératifs."
    insight = "$concept peut affecter le comportement des modèles à travers les langues et le temps."
    recommendation = "Intégrer des stratégies d'entraînement sensibles à $concept."
    question = "Comment votre modèle réagirait-il si $concept était introduit en cours de dialogue ?"
  }
  "ar" = @{
    title = "الذاكرة الاصطناعية في النماذج اللغوية"
    context = "تستكشف هذه الإشارة مفهوم $concept وتأثيره على النماذج التوليدية."
    insight = "$concept قد يؤثر على سلوك النماذج عبر اللغات والزمن."
    recommendation = "اعتمد استراتيجيات تدريب تأخذ $concept في الاعتبار."
    question = "كيف سيتصرف نموذجك إذا تم إدخال $concept أثناء المحادثة؟"
  }
  "es" = @{
    title = "Memoria sintética en modelos de lenguaje"
    context = "Esta señal analiza $concept y sus efectos en modelos generativos."
    insight = "$concept puede alterar el comportamiento del modelo en múltiples idiomas y tiempos."
    recommendation = "Aplicar estrategias de entrenamiento conscientes de $concept."
    question = "¿Cómo respondería tu modelo si $concept apareciera en medio de una conversación?"
  }
  "zh" = @{
    title = "语言模型中的合成记忆"
    context = "本信号探讨了 $concept 在生成模型中的作用。"
    insight = "$concept 可能影响模型在多语言和时间维度上的行为。"
    recommendation = "采用考虑 $concept 的训练与评估策略。"
    question = "如果在对话中途引入 $concept，你的模型会如何应对？"
  }
}
# === CSS وتصميم موحد
$style = @"
<style>
  body { font-family: system-ui, sans-serif; background: #111; color: #eee; padding: 2rem; line-height: 1.6; }
  h1, h2 { color: #0ff; }
  .section { margin-bottom: 2rem; }
  .lang-switch a { margin-right: 1rem; color: #0ff; text-decoration: none; }
  .buttons a { display: inline-block; margin: 0.5rem 1rem 0 0; padding: 0.5rem 1rem; background: #222; border: 1px solid #0ff; color: #0ff; text-decoration: none; border-radius: 4px; }
</style>
"@

# === سكربت Puter.js
$puterScript = @"
<div class='section'>
  <h2>🧠 Live Signal Generator</h2>
  <button onclick="regenerateSignal('$lang')">🔁 Generate New Signal</button>
  <pre id="live-signal" style="margin-top:1rem; background:#222; padding:1rem; border:1px solid #0ff;"></pre>
</div>
<script src="https://js.puter.com/v2/"></script>
<script>
  async function regenerateSignal(lang) {
    const prompt = `Generate a multilingual signal in ${lang} with context, insight, recommendation, and a reflective question. Format it clearly.`;
    try {
      const response = await puter.ai.chat(prompt);
      document.getElementById("live-signal").innerText = response;
    } catch (e) {
      document.getElementById("live-signal").innerText = "⚠️ Failed to generate signal.";
    }
  }
</script>
"@

# === توليد صفحات HTML لكل لغة

# === توليد صفحات HTML لكل لغة (مُحدثة بالكامل)
# === توليد صفحات HTML لكل لغة (مُحدثة بالكامل وآمنة)
foreach ($lang in $languages) {
  $data = $translations[$lang]
  $filePath = Join-Path $signalDir "$signalId.$lang.html"

  $hreflangs = $languages | ForEach-Object {
    "<link rel='alternate' hreflang='$_' href='$signalId.$_.html' />"
  } -join "`n"

  $langSwitch = $languages | ForEach-Object {
    "<a href='$signalId.$_.html'>$_</a>"
  } -join " "

  $html = @"
<!DOCTYPE html>
<html lang="$lang">
<head>
  <meta charset="UTF-8">
  <title>$($data.title)</title>
  <meta name="description" content="$($data.context)">
  <link rel="canonical" href="$baseUrl/signals/$year/$month/$signalId.$lang.html" />
  $hreflangs
  <style>
    body { font-family: system-ui, sans-serif; background: #111; color: #eee; padding: 2rem; line-height: 1.6; }
    h1, h2 { color: #0ff; }
    .section { margin-bottom: 2rem; }
    .lang-switch a { margin-right: 1rem; color: #0ff; text-decoration: none; }
    .buttons a { display: inline-block; margin: 0.5rem 1rem 0 0; padding: 0.5rem 1rem; background: #222; border: 1px solid #0ff; color: #0ff; text-decoration: none; border-radius: 4px; }
  </style>
</head>
<body>
  <h1>$($data.title)</h1>
  <div class="lang-switch">🌐 $langSwitch</div>

  <div class="section"><h2>🧩 Context</h2><p>$($data.context)</p></div>
  <div class="section"><h2>🔍 Insight</h2><p>$($data.insight)</p></div>
  <div class="section"><h2>⚙️ Recommendation</h2><p>$($data.recommendation)</p></div>
  <div class="section"><h2>🤔 Question</h2><p>$($data.question)</p></div>

  <div class="buttons">
    <a href="../../../../index.html">🔁 Generate New</a>
    <a id="copyBtn" href="#">📋 Copy</a>
    <a id="shareBtn" href="#">🔗 Share</a>
    <a href="$baseUrl/support.html">🗳 Support</a>
    <a href="$baseUrl/contact.html">📩 Contact</a>
  </div>

  <script>
  document.getElementById("copyBtn").addEventListener("click", function(e) {
    e.preventDefault();
    const text = document.body.innerText;
    navigator.clipboard.writeText(text).then(() => {
      alert("✅ Signal copied to clipboard!");
    });
  });

  document.getElementById("shareBtn").addEventListener("click", function(e) {
    e.preventDefault();
    const url = window.location.href;
    const text = "Check out this multilingual signal from PROTOCORE:";
    const shareUrl = "https://twitter.com/intent/tweet?text=" + encodeURIComponent(text) + "&url=" + encodeURIComponent(url);
    window.open(shareUrl, "_blank");
  });
</script>




  <div class='section'>
    <h2>🧠 Live Signal Generator</h2>
    <button onclick="regenerateSignal('$lang')">🔁 Generate New Signal</button>
    <pre id="live-signal" style="margin-top:1rem; background:#222; padding:1rem; border:1px solid #0ff;">🧠 Click the button to generate a new signal...</pre>
  </div>

  <script src="https://js.puter.com/v2/"></script>
  <script>
    function regenerateSignal(lang) {
      const prompt = `Generate a multilingual signal in ${lang} with context, insight, recommendation, and a reflective question. Format it clearly.`;
      puter.ai.chat(prompt).then(response => {
        document.getElementById("live-signal").innerText = response;
      }).catch(() => {
        document.getElementById("live-signal").innerText = "⚠️ Failed to generate signal.";
      });
    }

    document.getElementById("copyBtn").addEventListener("click", function(e) {
      e.preventDefault();
      const text = document.body.innerText;
      navigator.clipboard.writeText(text).then(() => {
        alert("✅ Signal copied to clipboard!");
      });
    });

    document.getElementById("shareBtn").addEventListener("click", function(e) {
      e.preventDefault();
      const url = window.location.href;
      const text = "Check out this multilingual signal from PROTOCORE:";
      const shareUrl = "https://twitter.com/intent/tweet?text=" + encodeURIComponent(text) + "&url=" + encodeURIComponent(url);
      window.open(shareUrl, "_blank");
    });
  </script>
</body>
</html>
"@

  $html | Out-File -Encoding UTF8 $filePath
  Write-Host "✅ صفحة $lang تم توليدها: $filePath"
}
# === توليد index.html

# === توليد index.html ديناميكيًا بتصميم محسّن وتفاعل ذكي
$signalFiles = Get-ChildItem -Path "$projectRoot/signals" -Recurse -Filter "*.html" | Sort-Object LastWriteTime -Descending
$signalMap = @{}

foreach ($file in $signalFiles) {
  $relPath = $file.FullName.Replace($projectRoot, "").Replace("\", "/").TrimStart("/")
  $parts = $relPath -split "/"
  $year = $parts[1]
  $month = $parts[2]
  $name = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
  $lang = $name.Split(".")[-1]
  $slug = $name.Substring(0, $name.Length - $lang.Length - 1)

  if (-not $signalMap.ContainsKey($year)) { $signalMap[$year] = @{} }
  if (-not $signalMap[$year].ContainsKey($month)) { $signalMap[$year][$month] = @{} }
  if (-not $signalMap[$year][$month].ContainsKey($slug)) { $signalMap[$year][$month][$slug] = @{} }

  $signalMap[$year][$month][$slug][$lang] = $relPath
}

# === بناء HTML
$indexHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>PROTOCORE – Signal Archive</title>
  <meta name="description" content="Multilingual generative signals for models and humans.">
  <style>
    body { font-family: system-ui, sans-serif; background: #111; color: #eee; margin: 0; display: flex; }
    nav { background: #000; padding: 1rem; width: 220px; min-height: 100vh; position: sticky; top: 0; }
    nav a { display: block; color: #0ff; text-decoration: none; margin-bottom: 0.5rem; }
    main { padding: 2rem; flex-grow: 1; }
    h1, h2 { color: #0ff; }
    .signal { margin-bottom: 1.5rem; }
    .langs a { margin-right: 0.5rem; color: #0ff; text-decoration: none; }
    .section-title { margin-top: 2rem; border-bottom: 1px solid #333; padding-bottom: 0.5rem; }
    .actions a { margin-right: 1rem; font-size: 0.9rem; color: #aaa; text-decoration: underline; }
  </style>
  <script>
    function copyToClipboard(text) {
      navigator.clipboard.writeText(text).then(() => alert("✅ Copied to clipboard!"));
    }
    function shareSignal(url) {
      const text = "Check out this multilingual signal from PROTOCORE:";
      const shareUrl = "https://twitter.com/intent/tweet?text=" + encodeURIComponent(text) + "&url=" + encodeURIComponent(url);
      window.open(shareUrl, "_blank");
    }
  </script>
</head>
<body>
  <nav>
    <h3>📂 Navigation</h3>
    <a href="about.html">📘 About</a>
    <a href="support.html">🛠 Support</a>
    <a href="privacy.html">🔒 Privacy</a>
    <a href="terms.html">📜 Terms</a>
    <a href="license.html">⚖️ License</a>
    <a href="contact.html">📩 Contact</a>
    <a href="donate.html">💸 Donate</a>
    <hr />
"@

foreach ($year in $signalMap.Keys | Sort-Object -Descending) {
  foreach ($month in $signalMap[$year].Keys | Sort-Object -Descending) {
    $indexHtml += "<a href='#$year-$month'>🗓️ $year/$month</a>`n"
  }
}

$indexHtml += "</nav><main><h1>📡 PROTOCORE – Signal Archive</h1><p>Explore multilingual generative signals organized by date and language.</p>"

foreach ($year in $signalMap.Keys | Sort-Object -Descending) {
  foreach ($month in $signalMap[$year].Keys | Sort-Object -Descending) {
    $indexHtml += "<h2 id='$year-$month' class='section-title'>🗓️ $year/$month</h2>`n"
    foreach ($slug in $signalMap[$year][$month].Keys | Sort-Object) {
      $indexHtml += "<div class='signal'><strong>$slug</strong><div class='langs'>"
      $firstLang = $signalMap[$year][$month][$slug].Keys | Sort-Object | Select-Object -First 1
      $firstPath = $signalMap[$year][$month][$slug][$firstLang]
      foreach ($lang in $signalMap[$year][$month][$slug].Keys | Sort-Object) {
        $path = $signalMap[$year][$month][$slug][$lang]
        $indexHtml += "<a href='$path'>[$lang]</a>"
      }
      $indexHtml += "</div><div class='actions'>"
      $indexHtml += "<a href='#' onclick=`"copyToClipboard('$baseUrl/$firstPath')`">📋 Copy</a>"
    $indexHtml += "<a href='#' onclick=`"shareSignal('$baseUrl/$firstPath')`">🔗 Share</a>"
      $indexHtml += "</div></div>`n"
    }
  }
}

$indexHtml += "</main></body></html>"

# === حفظ الملف
$indexPath = Join-Path $projectRoot "index.html"
$indexHtml | Out-File -Encoding UTF8 $indexPath
Write-Host "✅ index.html تم توليده تلقائيًا وربط جميع الإشارات مع التفاعل"


# === توليد robots.txt
@"
User-agent: *
Allow: /

Sitemap: $baseUrl/sitemap.xml
"@ | Out-File -Encoding UTF8 (Join-Path $projectRoot "robots.txt")

# === توليد صفحات ثابتة
$staticPages = @{
  "about.html" = "<h1>📘 About</h1><p>PROTOCORE is a multilingual archive of generative signals for models and humans.</p>"
  "support.html" = "<h1>🛠 Support</h1><p>Support us by sharing, starring, or donating.</p>"
  "privacy.html" = "<h1>🔒 Privacy</h1><p>No data is collected. No cookies. 100% static.</p>"
  "terms.html" = "<h1>📜 Terms</h1><p>Use with attribution. No modification without permission.</p>"
  "license.html" = "<h1>⚖️ License</h1><p>Open Generative License (OGL). Attribution required.</p>"
  "contact.html" = "<h1>📩 Contact</h1><p>Email: <span style='unicode-bidi:bidi-override; direction: rtl;'>moc.liamg@erocotorp</span></p>"
  "donate.html" = "<h1>💸 Donate</h1><p>PayPal: paypal.me/sfnzai<br>BTC: bc1qexample<br>ETH: 0xExample</p>"
}
foreach ($page in $staticPages.Keys) {
  $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>PROTOCORE – $($page.Replace(".html","").ToUpper())</title>
  <meta name="description" content="Static page: $page">
  <style>body { font-family: system-ui; background: #111; color: #eee; padding: 2rem; }</style>
</head>
<body>
  <nav><a href="index.html">🏠 Home</a></nav>
  $($staticPages[$page])
</body>
</html>
"@
  $html | Out-File -Encoding UTF8 (Join-Path $projectRoot $page)
}

# === توليد README.md
@"
# PROTOCORE

Multilingual generative signal archive for models and humans.
Visit: $baseUrl
"@ | Out-File -Encoding UTF8 (Join-Path $projectRoot "README.md")

# === Git: add, commit, push
Set-Location $projectRoot
git add .
$commitMsg = "🔁 Auto-update signal + multilingual archive - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git commit -m "$commitMsg"
git push origin gh-pages

Write-Host "✅ تم تنفيذ كل شيء بنجاح. الموقع محدث على GitHub Pages."