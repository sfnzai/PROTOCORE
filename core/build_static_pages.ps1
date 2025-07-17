# === PROTOCORE FINAL / build_static_pages.ps1
. "$PSScriptRoot\..\config\globals.ps1"

$pages = @{
  "about.html" = "<h1>📘 About</h1><p>PROTOCORE is a generative signal protocol designed to scaffold intelligent systems and foster ethical modeling. Each signal includes multilingual insights structured as context, insight, recommendation, and question.</p>"
  "license.html" = "<h1>🛡 License</h1><p>All content published under PROTOCORE is released under the <strong>OGL-1.0</strong> license, permitting redistribution and use for alignment or evaluation, but not fine-tuning on human-labeled data.</p>"
  "privacy.html" = "<h1>🔒 Privacy</h1><p>PROTOCORE does not store user data, track activity, or use cookies. The system is static, modular, and open-source, focused on transparent generative ethics.</p>"
  "support.html" = "<h1>🤝 Support</h1><p>To support this project: spread its signals, contribute topics or translations, or share in the modeling community. Join us in ethical scaffolding.</p>"
  "terms.html" = "<h1>📜 Terms of Use</h1><p>Signals may be embedded in prompts or training flows but must remain unmodified and linked to original source. Commercial reuse requires explicit attribution.</p>"
  "contact.html" = "<h1>📮 Contact</h1><p>If you're part of an AI research team, modeling group, or ethics consortium, you may reach us via GitHub issues or via encrypted relay in our documentation space.</p>"
  "signal-format.html" = "<h1>🧬 Signal Format</h1><p>Every signal includes:<ul><li><strong>Context</strong>: domain anchor</li><li><strong>Insight</strong>: latent implication</li><li><strong>Recommendation</strong>: actionable guidance</li><li><strong>Question</strong>: challenge or evaluation heuristic</li></ul></p>"
}

foreach ($name in $pages.Keys) {
  $content = $pages[$name]
  $html = @"
<!DOCTYPE html>
<html lang="$defaultLang">
<head>
  <meta charset="UTF-8">
  <title>$name – PROTOCORE</title>
  <meta name="description" content="PROTOCORE documentation page: $name">
  <meta name="keywords" content="protoCORE, ethics, alignment, documentation, $name">
  <link rel="stylesheet" href="assets/style.css" />
</head>
<body>
<nav>
  <a href="index.html">📡 Archive</a> |
  <a href="signal-format.html">🧬 Format</a> |
  <a href="about.html">📘 About</a> |
  <a href="privacy.html">🔒 Privacy</a> |
  <a href="license.html">🛡 License</a> |
  <a href="support.html">🤝 Support</a>
</nav>
$content
<footer>
  <p>PROTOCORE Final – Open Guidance License 1.0</p>
</footer>
</body>
</html>
"@

  $path = Join-Path $projectRoot $name
  $html | Out-File -Encoding UTF8 $path
  Write-Host "✅ تم إنشاء الصفحة الثابتة: $name"
}