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
foreach ($lang in $languages) {
  $data = $translations[$lang]
  $filePath = Join-Path $signalDir "$signalId.$lang.html"

  # === hreflang links
  $hreflangs = $languages | ForEach-Object {
    "<link rel='alternate' hreflang='$_' href='$signalId.$_.html' />"
  } -join "`n"

  # === روابط اللغات داخل الصفحة
  $langSwitch = $languages | ForEach-Object {
    "<a href='$signalId.$_.html'>$_</a>"
  } -join " "

  # === توليد HTML
  $html = @"
<!DOCTYPE html>
<html lang="$lang">
<head>
  <meta charset="UTF-8">
  <title>$($data.title)</title>
  <meta name="description" content="$($data.context)">
  <link rel="canonical" href="$baseUrl/signals/$year/$month/$signalId.$lang.html" />
  $hreflangs
  $style
</head>
<body>
  <h1>$($data.title)</h1>
  <div class="lang-switch">🌐 $langSwitch</div>

  <div class="section"><h2>🧩 Context</h2><p>$($data.context)</p></div>
  <div class="section"><h2>🔍 Insight</h2><p>$($data.insight)</p></div>
  <div class="section"><h2>⚙️ Recommendation</h2><p>$($data.recommendation)</p></div>
  <div class="section"><h2>🤔 Question</h2><p>$($data.question)</p></div>

  <div class="buttons">
    <a href="#">🔁 Generate New</a>
    <a href="#">📋 Copy</a>
    <a href="#">🔗 Share</a>
    <a href="$baseUrl/support.html">🗳 Support</a>
    <a href="$baseUrl/contact.html">📩 Contact</a>
  </div>

  $puterScript
</body>
</html>
"@

  $html | Out-File -Encoding UTF8 $filePath
  Write-Host "✅ صفحة $lang تم توليدها: $filePath"
}
# === توليد index.html
$signalFiles = Get-ChildItem -Path "$projectRoot/signals" -Recurse -Filter "*.html" | Sort-Object LastWriteTime -Descending
$signalMap = @{}
foreach ($file in $signalFiles) {
  $relPath = $file.FullName.Replace($projectRoot, "").Replace("\", "/").TrimStart("/")
  $name = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
  $lang = $name.Split(".")[-1]
  $slug = $name.Substring(0, $name.Length - $lang.Length - 1)
  if (-not $signalMap.ContainsKey($slug)) { $signalMap[$slug] = @{} }
  $signalMap[$slug][$lang] = $relPath
}
$indexHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>PROTOCORE – Multilingual Signal Archive</title>
  <meta name="description" content="A multilingual archive of generative signals for models and humans.">
  <style>
    body { font-family: system-ui, sans-serif; background: #111; color: #eee; padding: 2rem; }
    h1 { color: #0ff; }
    .signal { margin-bottom: 1.5rem; }
    .langs a { margin-right: 0.5rem; color: #0ff; text-decoration: none; }
  </style>
</head>
<body>
  <h1>📡 PROTOCORE – Signal Archive</h1>
  <p>Latest multilingual generative signals:</p>
"@
foreach ($slug in $signalMap.Keys) {
  $indexHtml += "<div class='signal'><strong>$slug</strong><div class='langs'>"
  foreach ($lang in $signalMap[$slug].Keys) {
    $path = $signalMap[$slug][$lang]
    $indexHtml += "<a href='$path'>[$lang]</a>"
  }
  $indexHtml += "</div></div>`n"
}
$indexHtml += "</body></html>"
$indexHtml | Out-File -Encoding UTF8 (Join-Path $projectRoot "index.html")

# === توليد sitemap.xml
$sitemap = @()
$sitemap += '<?xml version="1.0" encoding="UTF-8"?>'
$sitemap += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
foreach ($file in $signalFiles) {
  $relPath = $file.FullName.Replace($projectRoot, "").Replace("\", "/").TrimStart("/")
  $url = "$baseUrl/$relPath"
  $lastmod = (Get-Date $file.LastWriteTimeUtc -Format "yyyy-MM-dd")
  $sitemap += "  <url><loc>$url</loc><lastmod>$lastmod</lastmod></url>"
}
$sitemap += '</urlset>'
$sitemap -join "`n" | Out-File -Encoding UTF8 (Join-Path $projectRoot "sitemap.xml")

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