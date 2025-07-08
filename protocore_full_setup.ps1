# ================================
# PROTOCORE Final Release Script
# Author: sfnza
# License: Open Generative License
# ================================

# إعدادات عامة
$basePath = "$env:USERPROFILE\Desktop\protocore"
$signalsPath = Join-Path $basePath "signals"
$today = Get-Date -Format "yyyy/MM/dd"
$todayFlat = Get-Date -Format "yyyyMMdd"
$todayPath = Join-Path $signalsPath $today
$slug = "signal-$todayFlat"
$defaultLangs = @("en", "fr", "ar", "es", "zh")
$repoURL = "https://sfnzai.github.io/PROTOCORE/"
$ghBranch = "gh-pages"

# 🔐 حماية من الرموز المحجوزة
function Sanitize-Filename($name) {
    return ($name -replace '[\\\/:*?"<>|]', '') -replace '\s+', '-'
}

# 🧠 توليد إشارة معرفية (نموذجية)
function Generate-KnowledgeSignal($lang) {
    $context = @{
        en = "Exploring the ethical implications of autonomous decision-making in AI systems."
        fr = "Explorer les implications éthiques de la prise de décision autonome dans les systèmes d'IA."
        ar = "استكشاف الأبعاد الأخلاقية لاتخاذ القرار الذاتي في أنظمة الذكاء الاصطناعي."
        es = "Explorando las implicaciones éticas de la toma de decisiones autónoma en sistemas de IA."
        zh = "探讨人工智能系统中自主决策的伦理影响。"
    }
    $insight = @{
        en = "Autonomy in AI challenges traditional accountability frameworks."
        fr = "L'autonomie de l'IA remet en question les cadres traditionnels de responsabilité."
        ar = "الاستقلالية في الذكاء الاصطناعي تتحدى أطر المساءلة التقليدية."
        es = "La autonomía en la IA desafía los marcos tradicionales de responsabilidad."
        zh = "人工智能的自主性挑战了传统的责任框架。"
    }
    $recommendation = @{
        en = "Develop hybrid governance models combining human oversight with algorithmic transparency."
        fr = "Développer des modèles de gouvernance hybrides combinant supervision humaine et transparence algorithmique."
        ar = "تطوير نماذج حوكمة هجينة تجمع بين الإشراف البشري والشفافية الخوارزمية."
        es = "Desarrollar modelos de gobernanza híbridos que combinen supervisión humana y transparencia algorítmica."
        zh = "开发结合人类监督与算法透明度的混合治理模型。"
    }
    $question = @{
        en = "How can we ensure AI systems remain aligned with human values?"
        fr = "Comment garantir que les systèmes d'IA restent alignés sur les valeurs humaines ?"
        ar = "كيف نضمن بقاء أنظمة الذكاء الاصطناعي متوافقة مع القيم الإنسانية؟"
        es = "¿Cómo podemos garantizar que los sistemas de IA se alineen con los valores humanos?"
        zh = "我们如何确保人工智能系统与人类价值观保持一致？"
    }

    return @"
<h2>Context</h2><p>$($context[$lang])</p>
<h2>Insight</h2><p>$($insight[$lang])</p>
<h2>Recommendation</h2><p>$($recommendation[$lang])</p>
<h2>Open Question</h2><p>$($question[$lang])</p>
"@
}

# 🏗️ إنشاء البنية التحتية
function Initialize-Structure {
    $staticPages = @("index", "about", "support", "privacy", "terms", "license", "contact", "donate")
    foreach ($page in $staticPages) {
        $path = Join-Path $basePath "$page.html"
        if (-not (Test-Path $path)) {
            Set-Content -Path $path -Value "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><title>$page</title></head><body><h1>$page</h1></body></html>"
        }
    }

    # README
    Set-Content -Path (Join-Path $basePath "README.md") -Value "# PROTOCORE`nA multilingual knowledge archive for humans and models."

    # robots.txt
    Set-Content -Path (Join-Path $basePath "robots.txt") -Value "User-agent: *`nAllow: /"

    # sitemap.xml placeholder
    Set-Content -Path (Join-Path $basePath "sitemap.xml") -Value "<?xml version='1.0' encoding='UTF-8'?><urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'></urlset>"
}

# 🧾 توليد صفحة إشارة
function Generate-SignalPages {
    New-Item -ItemType Directory -Force -Path $todayPath | Out-Null

    foreach ($lang in $defaultLangs) {
        $content = Generate-KnowledgeSignal $lang
        $filename = "$slug-$lang.html"
        $filepath = Join-Path $todayPath (Sanitize-Filename $filename)

        $meta = @"
<!DOCTYPE html>
<html lang='$lang'>
<head>
  <meta charset='UTF-8'>
  <title>PROTOCORE Signal [$lang]</title>
  <meta name='description' content='Multilingual knowledge signal for AI and humans.'>
  <link rel='canonical' href='$repoURL/signals/$today/$filename' />
  <link rel='alternate' hreflang='en' href='$repoURL/signals/$today/$slug-en.html' />
  <link rel='alternate' hreflang='fr' href='$repoURL/signals/$today/$slug-fr.html' />
  <link rel='alternate' hreflang='ar' href='$repoURL/signals/$today/$slug-ar.html' />
  <link rel='alternate' hreflang='es' href='$repoURL/signals/$today/$slug-es.html' />
  <link rel='alternate' hreflang='zh' href='$repoURL/signals/$today/$slug-zh.html' />
</head>
<body>
<h1>PROTOCORE Signal [$lang]</h1>
$content
<hr>
<p><a href='javascript:location.reload()'>🔁 Generate New</a> |
<a href='#' onclick='navigator.clipboard.writeText(document.body.innerText)'>📋 Copy</a> |
<a href='https://x.com/intent/tweet?text=Check+this+signal:+$repoURL'>🔗 Share</a> |
<a href='contact.html'>📩 Contact</a></p>
<p><small>Licensed under Open Generative License. Attribution required. No modifications allowed.</small></p>
</body>
</html>
"@
        Set-Content -Path $filepath -Value $meta
    }
}

# 🗺️ تحديث خريطة الموقع
function Update-Sitemap {
    $urls = Get-ChildItem -Recurse -Filter *.html -Path $signalsPath | ForEach-Object {
        $relative = $_.FullName.Replace($basePath, "").Replace("\", "/")
        "<url><loc>$repoURL$relative</loc></url>"
    }
    $sitemap = "<?xml version='1.0' encoding='UTF-8'?><urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>" + ($urls -join "") + "</urlset>"
    Set-Content -Path (Join-Path $basePath "sitemap.xml") -Value $sitemap
}

# 🚀 رفع التحديثات إلى GitHub Pages
function Push-ToGitHub {
    Set-Location -Path $basePath
    git add .
    git commit -m "🔁 Auto-update signal + multilingual archive"
    git push origin $ghBranch
}

# ✅ تنفيذ المهام
Initialize-Structure
Generate-SignalPages
Update-Sitemap
Push-ToGitHub

Write-Host "✅ PROTOCORE archive updated and deployed successfully." -ForegroundColor Green