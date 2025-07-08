# تحديد المتغيرات الأساسية
$baseUrl = "https://sfnzai.github.io/PROTOCORE"
$signalDir = "$env:USERPROFILE\Desktop\protocore\signals"
$languages = @("en", "fr", "de", "ar")  # أضف المزيد من اللغات هنا حسب الحاجة
$translations = @{
    en = @{ title = "Daily Signal: English"; context = "Context in English"; insight = "Insight in English"; recommendation = "Recommendation in English"; question = "Question in English" }
    fr = @{ title = "Signal Quotidien: Français"; context = "Contexte en français"; insight = "Perspective en français"; recommendation = "Recommandation en français"; question = "Question en français" }
    de = @{ title = "Tägliches Signal: Deutsch"; context = "Kontext auf Deutsch"; insight = "Einblick auf Deutsch"; recommendation = "Empfehlung auf Deutsch"; question = "Frage auf Deutsch" }
    ar = @{ title = "الإشارة اليومية: العربية"; context = "السياق بالعربية"; insight = "رؤية بالعربية"; recommendation = "توصية بالعربية"; question = "سؤال بالعربية" }
}

# إنشاء المجلد إذا لم يكن موجودًا
if (-Not (Test-Path -Path $signalDir)) {
    New-Item -Path $signalDir -ItemType Directory
}

# تعريف الدالة لإنشاء ملف HTML جديد لكل إشعار يومي
foreach ($lang in $languages) {
    $data = $translations[$lang]
    $signalId = (Get-Date -Format "yyyyMMddHHmmss")  # استخدام توقيت الآن لتوليد معرف فريد
    $signalFilePath = Join-Path $signalDir "$signalId.$lang.html"
    
    $htmlContent = @"
    <!DOCTYPE html>
    <html lang="$lang">
    <head>
        <meta charset="UTF-8">
        <title>$($data.title)</title>
        <meta name="description" content="$($data.context)">
        <link rel="canonical" href="$baseUrl/signals/$signalId.$lang.html" />
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
        <div class="lang-switch">🌐 $lang</div>
        <div class="section"><h2>🧩 Context</h2><p>$($data.context)</p></div>
        <div class="section"><h2>🔍 Insight</h2><p>$($data.insight)</p></div>
        <div class="section"><h2>⚙️ Recommendation</h2><p>$($data.recommendation)</p></div>
        <div class="section"><h2>🤔 Question</h2><p>$($data.question)</p></div>
        <div class="buttons">
            <a href="../../../../index.html">🔁 Generate New</a>
            <a href="#" id="copyBtn">📋 Copy</a>
            <a href="#" id="shareBtn">🔗 Share</a>
            <a href="$baseUrl/support.html">🗳 Support</a>
            <a href="$baseUrl/contact.html">📩 Contact</a>
        </div>

        <!-- Puter.js Script -->
        <script src="https://js.puter.com/v2/"></script>
        <script>
            async function regenerateSignal(lang) {
                const prompt = \`Generate a multilingual signal in \${lang} with context, insight, recommendation, and a reflective question. Format it clearly.\`;
                try {
                    const response = await puter.ai.chat(prompt);
                    document.getElementById("live-signal").innerText = response;
                } catch (e) {
                    document.getElementById("live-signal").innerText = "⚠️ Failed to generate signal.";
                }
            }
        </script>
    </body>
    </html>
"@

    # كتابة المحتوى إلى الملف
    Set-Content -Path $signalFilePath -Value $htmlContent
}

# تحديث الصفحة الرئيسية تلقائيًا
$indexFilePath = "$env:USERPROFILE\Desktop\protocore\index.html"
$indexContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PROTOCORE Daily Signals</title>
    <style>
        body { font-family: system-ui, sans-serif; background: #111; color: #eee; padding: 2rem; line-height: 1.6; }
        h1 { color: #0ff; }
        .signal-link { display: block; margin-bottom: 1rem; color: #0ff; text-decoration: none; }
    </style>
</head>
<body>
    <h1>PROTOCORE Daily Signals</h1>
    <p>Welcome to the daily signals page. Click below to view the latest signals in multiple languages:</p>

"@

# إضافة روابط الإشارات اليومية
$signalFiles = Get-ChildItem -Path $signalDir -Filter "*.html" | Sort-Object LastWriteTime -Descending
foreach ($signalFile in $signalFiles) {
    $signalLink = "<a class='signal-link' href='$baseUrl/signals/$($signalFile.Name)'>$($signalFile.Name)</a>"
    $indexContent += $signalLink
}

# إنهاء صفحة index
$indexContent += @"
</body>
</html>
"@

# كتابة محتوى الصفحة الرئيسية
Set-Content -Path $indexFilePath -Value $indexContent

Write-Host "تم إنشاء الإشارات اليومية وتحديث الصفحة الرئيسية بنجاح!"
