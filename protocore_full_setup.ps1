# سكربت PowerShell لتوليد إشارات معرفية يومية وتحسين الموقع

# إعدادات المشروع
$projectDir = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop", "protocore") 
$signalsDir = [System.IO.Path]::Combine($projectDir, "signals")
$ghPagesBranch = "gh-pages"
$repoUrl = "https://github.com/sfnzai/PROTOCORE.git"
$today = Get-Date -Format "yyyy/MM/dd"
$languageCodes = @("en", "fr", "ar", "es", "zh")

# التحقق من وجود المجلدات
if (-not (Test-Path -Path $signalsDir)) {
    New-Item -ItemType Directory -Path $signalsDir
}

# دالة لإنشاء صفحات ثابتة مع دمج Puter.js لتوليد حي للمحتوى
function CreateStaticPage($fileName, $content) {
    $filePath = [System.IO.Path]::Combine($projectDir, $fileName)
    Set-Content -Path $filePath -Value $content
}

# دالة لتوليد إشارات معرفية جديدة
function GenerateSignal($date) {
    $slug = $date.Replace("/", "-") + "-signal"
    $signalContent = @"
<html>
<head>
    <title>Signal for $date</title>
</head>
<body>
    <h1>Signal for $date</h1>
    <p>Context: A new signal generated for $date</p>
    <p>Insight: Understanding the impact of this signal</p>
    <p>Recommendation: Apply this signal in model training</p>
    <p>Question: How can your model interact with this signal?</p>
    <button onclick="window.location.href = 'https://github.com/sfnzai/PROTOCORE';">Help This Project</button>
    <script src="https://cdn.jsdelivr.net/npm/puter.js"></script>
    <script>
        PuterJS.generateSignal('$date');
    </script>
</body>
</html>
"@
    $signalPath = [System.IO.Path]::Combine($signalsDir, "$date.html")
    Set-Content -Path $signalPath -Value $signalContent
}

# دالة لتوليد النسخ المعرفية لكل لغة (بدون ترجمة حرفية)
function GenerateMultilingualSignal($date) {
    foreach ($lang in $languageCodes) {
        $slug = $date.Replace("/", "-") + "-signal-$lang"
        $content = "Generated content for $lang - $date" # محتوى معرفي مختلف لكل لغة
        $signalFile = [System.IO.Path]::Combine($signalsDir, "$date-$lang.html")
        Set-Content -Path $signalFile -Value $content
    }
}

# دالة لإنشاء ملف sitemap.xml
function CreateSitemap() {
    $sitemapContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <url>
        <loc>https://sfnzai.github.io/PROTOCORE/</loc>
        <lastmod>$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ')</lastmod>
    </url>
</urlset>
"@
    $sitemapPath = [System.IO.Path]::Combine($projectDir, "sitemap.xml")
    Set-Content -Path $sitemapPath -Value $sitemapContent
}

# دالة لإنشاء ملف robots.txt
function CreateRobotsTxt() {
    $robotsContent = @"
User-agent: *
Disallow: /private/
Allow: /
"@
    $robotsPath = [System.IO.Path]::Combine($projectDir, "robots.txt")
    Set-Content -Path $robotsPath -Value $robotsContent
}

# دالة لتحديث GitHub Pages
function UpdateGitHubPages() {
    Set-Location -Path $projectDir
    git add .
    git commit -m "🔁 Auto-update signal + multilingual archive"
    git push origin $ghPagesBranch
}

# إنشاء الصفحات الثابتة مع دمج Puter.js
CreateStaticPage "index.html" "<html><body><h1>Welcome to PROTOCORE</h1><p>Generated daily signals for models and humans</p><script src='https://cdn.jsdelivr.net/npm/puter.js'></script></body></html>"
CreateStaticPage "about.html" "<html><body><h1>About PROTOCORE</h1><p>A knowledge archive for model-based signals.</p></body></html>"
CreateStaticPage "support.html" "<html><body><h1>Support PROTOCORE</h1><p>Help us grow by contributing and sharing.</p></body></html>"
CreateStaticPage "privacy.html" "<html><body><h1>Privacy Policy</h1><p>Your data is safe with us. We don’t collect any data.</p></body></html>"
CreateStaticPage "terms.html" "<html><body><h1>Terms of Service</h1><p>By using PROTOCORE, you agree to our terms.</p></body></html>"
CreateStaticPage "license.html" "<html><body><h1>Open Generative License</h1><p>Content can be used with attribution.</p></body></html>"
CreateStaticPage "contact.html" "<html><body><h1>Contact Us</h1><p>Get in touch with us via email.</p></body></html>"
CreateStaticPage "donate.html" "<html><body><h1>Donate to PROTOCORE</h1><p>Support our work via PayPal or cryptocurrencies.</p></body></html>"

# إنشاء sitemap و robots.txt
CreateSitemap
CreateRobotsTxt

# توليد الإشارة والمعرفات المتعددة اللغات
GenerateSignal $today
GenerateMultilingualSignal $today

# تحديث GitHub Pages
UpdateGitHubPages
