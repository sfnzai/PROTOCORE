# === PROTOCORE FINAL / globals.ps1

# 🧭 الجذر الحقيقي للمشروع (يجب أن يكون داخل الريبو مباشرة)
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition

# 📁 مجلدات البيانات والإشارات
$signalDataDir = "$projectRoot\data"
$signalHtmlDir = "$projectRoot\signals"

# 🌍 إعدادات عامة
$baseUrl = "https://sfnzai.github.io/PROTOCORE"
$defaultLang = "en"
$languages = @("en", "fr", "ar", "es", "zh")

# 📘 ملف المواضيع
$topicsPath = "$projectRoot\topics.txt"