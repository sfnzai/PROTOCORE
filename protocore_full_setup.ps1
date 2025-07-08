# ------------------------------
# إعدادات المشروع - DEFINE
# ------------------------------
$projectFolder = "$env:USERPROFILE\Desktop\protocore"
$signalsFolder = "$projectFolder\signals"
$repoUrl = "https://sfnzai.github.io/PROTOCORE/"
$gitHubBranch = "gh-pages"

# ------------------------------
# 1. إنشاء البنية التحتية
# ------------------------------
# إذا لم تكن المجلدات موجودة، قم بإنشائها
if (-Not (Test-Path -Path $signalsFolder)) {
    New-Item -ItemType Directory -Force -Path $signalsFolder
}

# توليد صفحات ثابتة
$staticPages = @("index.html", "about.html", "support.html", "privacy.html", "terms.html", "license.html", "contact.html", "donate.html")
foreach ($page in $staticPages) {
    $pagePath = "$projectFolder\$page"
    New-Item -ItemType File -Path $pagePath -Force
}

# توليد ملف README.md
$readme = "$projectFolder\README.md"
Set-Content -Path $readme -Value "# PROTOCORE Project"
  
# توليد ملف sitemap.xml و robots.txt
$sitemap = "$projectFolder\sitemap.xml"
$robotsTxt = "$projectFolder\robots.txt"

Set-Content -Path $sitemap -Value "<urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'></urlset>"
Set-Content -Path $robotsTxt -Value "User-agent: *`nAllow: /"

# ------------------------------
# 2. توليد الإشارات
# ------------------------------
# توليد إشارة معرفية غير مكررة
function GenerateSignal {
    $date = Get-Date -Format "yyyy/MM/dd"
    $signalFileName = "$signalsFolder\$date.html"
    
    $signalContent = @"
    <html>
    <head>
        <title>Signal for $date</title>
    </head>
    <body>
        <h1>Context</h1>
        <p>Insight</p>
        <p>Recommendation</p>
        <p>Open Question</p>
    </body>
    </html>
"@
    Set-Content -Path $signalFileName -Value $signalContent
}

GenerateSignal

# ------------------------------
# 3. SEO التعديل
# ------------------------------
# تحديث sitemap.xml تلقائيًا
$sitemapContent = Get-Content $sitemap
$sitemapContent += "<url><loc>$repoUrl</loc></url>"
Set-Content -Path $sitemap -Value $sitemapContent

# ------------------------------
# 4. التفاعل - أزرار على الصفحات
# ------------------------------
$buttonHtml = @"
    <button onclick="location.href='/signals';">Generate New Signal</button>
    <button onclick="copyToClipboard()">Copy Signal</button>
    <button onclick="location.href='/contact';">Contact Us</button>
"@

foreach ($page in $staticPages) {
    $pagePath = "$projectFolder\$page"
    Add-Content -Path $pagePath -Value $buttonHtml
}

# ------------------------------
# 5. رفع التحديثات إلى GitHub
# ------------------------------
cd $projectFolder
git add .
git commit -m "🔁 Auto-update signal + multilingual archive"
git push origin $gitHubBranch
