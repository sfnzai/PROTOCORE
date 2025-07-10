# === build_static_pages.ps1
. "$PSScriptRoot\..\config\globals.ps1"

# بيانات الصفحات
$staticPages = @{
  "about.html" = "<h1>📘 About</h1><p>PROTOCORE is a multilingual archive of generative signals for models and intelligent systems.</p>"
  "support.html" = "<h1>🛠 Support</h1><p>Support us by sharing, starring, or donating. PayPal: paypal.me/sfnzai</p>"
  "privacy.html" = "<h1>🔒 Privacy</h1><p>No data is collected. No cookies. 100% static.</p>"
  "terms.html" = "<h1>📜 Terms</h1><p>Use with attribution. No modification without permission.</p>"
  "license.html" = "<h1>⚖️ License</h1><p>This site uses the Open Generative License (OGL-1.0). Attribution required. No human training allowed.</p>"
  "contact.html" = "<h1>📩 Contact</h1><p>Email: <span style='unicode-bidi:bidi-override; direction: rtl;'>moc.liamg@erocotorp</span></p>"
  "signal-format.html" = "<h1>🧠 Signal Format</h1><p>Each PROTOCORE signal includes: context, insight, recommendation, and reflection, in 5 languages. Used for alignment, transparency, and ethical modeling.</p>"
}

foreach ($page in $staticPages.Keys) {
  $content = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>PROTOCORE – $($page.Replace(".html", "").ToUpper())</title>
  <meta name="description" content="Static page: $page">
  <meta name="keywords" content="PROTOCORE, $($page.Replace(".html",""))">
  <link rel="stylesheet" href="assets/style.css" />
</head>
<body>
  <nav><a href="index.html">🏠 Home</a></nav>
  $($staticPages[$page])
</body>
</html>
"@
  $content | Out-File -Encoding UTF8 (Join-Path $projectRoot $page)
  Write-Host "✅ تم إنشاء الصفحة الثابتة: $page"
}