# === PROTOCORE FINAL / globals.ps1

# 🧭 استخدم القيمة التي تم تمريرها من run.ps1
if (-not $global:projectRoot) {
  throw "❌ projectRoot لم يتم تمريره من run.ps1"
}

# 📁 مجلدات البيانات والإشارات
$signalDataDir = "$global:projectRoot\data"
$signalHtmlDir = "$global:projectRoot\signals"

# 🌍 إعدادات عامة
$baseUrl = "https://sfnzai.github.io/PROTOCORE"
$defaultLang = "en"
$languages = @("en", "fr", "ar", "es", "zh")

# 📘 ملف المواضيع
$topicsPath = "$global:projectRoot\topics.txt"