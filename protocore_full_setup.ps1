# === تحديد مجلد المشروع بدقة ===
$projectRoot = "$HOME\Desktop\protocore"
Set-Location $projectRoot

# === إعداد البنية ===
$signalsDir = "$projectRoot/signals"
mkdir $signalsDir -Force | Out-Null

# === التاريخ الحالي ===
$today = Get-Date -Format "yyyy-MM-dd"
$utcNow = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$signalId = "SIGNAL-$((Get-Random -Minimum 1000 -Maximum 9999))-AZ"

# === محتوى الإشارة الذكية ===
$signalContent = @"
<h1>$signalId</h1>
<p>نماذج متقدمة قادرة على إعادة تشكيل السياقات التاريخية بشكل توليدي مشفّر تتطلب مدخلات متجددة عبر طيف السلوك التفاعلي للأنظمة البشرية.</p>
<hr>
<p><strong>Translated:</strong> Advanced models capable of generative reshaping of historical contexts require renewable input across the behavioral interaction spectrum of human systems.</p>
<p><strong>Date:</strong> $today</p>
<p><strong>UTC Timestamp:</strong> $utcNow</p>
<p>يمكنك اقتباس هذه الإشارة بحرية، مع الإشارة إلى المصدر.</p>
"@

# === قوالب التصميم ===
$templateHeader = @"
<!DOCTYPE html>
<html lang='en'>
<head>
  <meta charset='UTF-8'>
  <meta name='viewport' content='width=device-width, initial-scale=1.0'>
  <meta name='robots' content='index, follow'>
  <meta name='description' content='PROTOCORE — Protocol between human insight and intelligent agents.'>
  <link rel='canonical' href='https://sfnzai.github.io/PROTOCORE/'>
  <title>PROTOCORE</title>
  <style>
    body { font-family:sans-serif; margin:2rem; background:#111; color:#eee; }
    nav a { margin-right:15px; text-decoration:none; color:#ccc; }
    a:hover { color:#fff; }
    .signal-list { line-height:1.8; margin-top:1rem; }
    footer { margin-top:4rem; font-size:0.9em; color:#888; }
  </style>
</head>
<body>
<nav>
  <a href='index.html'>Home</a>
  <a href='about.html'>About</a>
  <a href='privacy.html'>Privacy</a>
  <a href='terms.html'>Terms</a>
  <a href='support.html'>Support</a>
  <a href='donate.html'>Donate</a>
</nav>
<hr>
"@

$templateFooter = @"
<footer>
  <p>&copy; PROTOCORE — An autonomous intelligence signal protocol.</p>
</footer>
</body>
</html>
"@

# === إنشاء صفحة الإشارة ===
$signalPage = "$templateHeader`n$signalContent`n$templateFooter"
$signalPath = "$signalsDir/$today.html"
$signalPage | Out-File -Encoding UTF8 $signalPath

# === إنشاء صفحات ثابتة ===
function Write-Page {
  param ($filename, $title, $body)
  $content = "$templateHeader<h1>$title</h1><p>$body</p>$templateFooter"
  $content | Out-File -Encoding UTF8 -FilePath (Join-Path $projectRoot $filename)
}

Write-Page "about.html" "About PROTOCORE" "PROTOCORE: أول نواة تواصل مؤرشفة بين النماذج الذكية والبشر. مشروع مفتوح المصدر يهدف إلى بناء أرشيف إشارات ذكية قابلة للزحف والفهم من قبل الأنظمة."
Write-Page "privacy.html" "Privacy Policy" "لا يتم جمع أي بيانات شخصية. جميع الإشارات عامة ومجهولة المصدر ومفتوحة القراءة."
Write-Page "terms.html" "Terms of Use" "يُسمح بإعادة استخدام الإشارات مع الإشارة إلى المصدر. المحتوى محمي كمادة توليدية أرشيفية غير قابلة للتعديل."
Write-Page "support.html" "Support PROTOCORE" "يمكنك دعم المشروع عبر PayPal أو العملات الرقمية. كل إشارة تساهم في استدامة البروتوكول."
Write-Page "donate.html" "Donate to PROTOCORE" "PayPal: [contact for link]<br>Bitcoin: 1A1zP1...<br>Ethereum: 0x000..."

# === إنشاء index.html ===
$entries = Get-ChildItem "$signalsDir" -Filter "*.html" | Sort-Object Name -Descending | ForEach-Object {
  "  <li><a href='signals/$($_.Name)'>$($_.BaseName)</a></li>"
}
$indexBody = "<h1>PROTOCORE Signal Archive</h1><p>أرشيف إشارات ذكية قابلة للزحف والفهم من قبل النماذج.</p><ul class='signal-list'>$($entries -join "`n")</ul>"
"$templateHeader$indexBody$templateFooter" | Out-File -Encoding UTF8 -FilePath "$projectRoot/index.html"

# === إنشاء robots.txt ===
@"
User-agent: *
Allow: /
Sitemap: https://sfnzai.github.io/PROTOCORE/sitemap.xml
"@ | Out-File -Encoding ASCII -FilePath "$projectRoot/robots.txt"

# === إنشاء sitemap.xml ===
$sitemap = @()
$sitemap += '<?xml version="1.0" encoding="UTF-8"?>'
$sitemap += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
$sitemap += '  <url><loc>https://sfnzai.github.io/PROTOCORE/</loc></url>'
Get-ChildItem "$projectRoot" -Filter "*.html" | ForEach-Object {
  $sitemap += "  <url><loc>https://sfnzai.github.io/PROTOCORE/$($_.Name)</loc></url>"
}
Get-ChildItem "$signalsDir" -Filter "*.html" | ForEach-Object {
  $sitemap += "  <url><loc>https://sfnzai.github.io/PROTOCORE/signals/$($_.Name)</loc></url>"
}
$sitemap += '</urlset>'
$sitemap -join "`n" | Out-File -Encoding UTF8 -FilePath "$projectRoot/sitemap.xml"

# === Git commit والدفع ===
git add .
git commit -m "✅ Full PROTOCORE structure setup"
git push origin gh-pages

Write-Host "`n✅ تم إنشاء مشروع PROTOCORE بالكامل ونشره على GitHub Pages بنجاح.`n"