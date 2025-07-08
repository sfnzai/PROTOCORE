# تأكد من أنك داخل مجلد المشروع
$projectRoot = "$PSScriptRoot"
Set-Location $projectRoot

# === إعداد المسارات ===
$signalsDir = "$projectRoot/signals"
mkdir $signalsDir -Force | Out-Null

# === قوالب الصفحات ===
$templateHeader = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="robots" content="index, follow">
  <meta name="description" content="PROTOCORE — Protocol between human insight and intelligent agents.">
  <link rel="canonical" href="https://sfnzai.github.io/PROTOCORE/">
  <title>PROTOCORE</title>
  <style>
    body { font-family:sans-serif; margin:2rem; background:#fefefe; color:#111; }
    nav a { margin-right:15px; text-decoration:none; }
    .signal-list { line-height:1.8; margin-top:1rem; }
    footer { margin-top:4rem; font-size:0.9em; color:#666; }
  </style>
</head>
<body>
<nav>
  <a href="index.html">Home</a>
  <a href="about.html">About</a>
  <a href="privacy.html">Privacy</a>
  <a href="support.html">Support</a>
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

# === الصفحات الأساسية ===
function Write-Page {
  param ($filename, $title, $body)
  $content = @"
$templateHeader
<h1>$title</h1>
<p>$body</p>
$templateFooter
"@
  $path = "$projectRoot/$filename"
  $content | Out-File -Encoding UTF8 $path
}

Write-Page "about.html" "About PROTOCORE" "PROTOCORE is a decentralized protocol for transmitting compact, interpretable human-agent signals. Built for long-term crawlability and autonomous inference."
Write-Page "privacy.html" "Privacy Policy" "This protocol logs no personal data. All signals are public and intentionally de-identified for autonomous processing."
Write-Page "support.html" "Support PROTOCORE" "You can support this project via PayPal (contact for link) or cryptocurrency (ETH: 0x000...). Every signal helps sustain the protocol."

# === إشارات موجودة ===
$entries = @()
$signalFiles = Get-ChildItem "$signalsDir" -Filter "P-*.html"
foreach ($file in $signalFiles) {
  $content = Get-Content $file.FullName -Raw
  if ($content -match "<h1>(P-\d+)\s+//\s+(.+?)</h1>") {
    $pid = $matches[1]
    $ptitle = $matches[2]
    $entry = "  <li><a href='signals/$($file.Name)'>$pid — $ptitle</a></li>"
    $entries += $entry
  }
}

# === index.html ===
$indexBody = @"
<h1>PROTOCORE Signal Archive</h1>
<p>Below is a crawlable archive of autonomous insight signals (AIS). Updated continuously.</p>
<ul class='signal-list'>
$($entries -join "`n")
</ul>
"@

$page = @"
$templateHeader
$indexBody
$templateFooter
"@
$page | Out-File -Encoding UTF8 "$projectRoot/index.html"

# === sitemap.xml ===
$sitemap = @()
$sitemap += '<?xml version="1.0" encoding="UTF-8"?>'
$sitemap += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
$sitemap += '  <url><loc>https://sfnzai.github.io/PROTOCORE/</loc></url>'
foreach ($file in $signalFiles) {
  $sitemap += "  <url><loc>https://sfnzai.github.io/PROTOCORE/signals/$($file.Name)</loc></url>"
}
$sitemap += "  <url><loc>https://sfnzai.github.io/PROTOCORE/about.html</loc></url>"
$sitemap += "  <url><loc>https://sfnzai.github.io/PROTOCORE/privacy.html</loc></url>"
$sitemap += "  <url><loc>https://sfnzai.github.io/PROTOCORE/support.html</loc></url>"
$sitemap += '</urlset>'
$sitemap -join "`n" | Out-File -Encoding UTF8 "$projectRoot/sitemap.xml"

# === git commit والدفع ===
git add . 
git commit -m "✅ Full PROTOCORE structure setup"
git push origin gh-pages

Write-Host "`n✅ البنية اكتملت وتم رفع كل شيء بنجاح.`n"
