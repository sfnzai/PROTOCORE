# === globals.ps1 — إعدادات المشروع العامة

# 🗂 المسارات
$desktop = [Environment]::GetFolderPath("Desktop")
$projectRoot = Join-Path $desktop "protocore_modular"
$signalDataDir = Join-Path $projectRoot "data"
$signalHtmlDir = Join-Path $projectRoot "signals"
$assetsDir = Join-Path $projectRoot "assets"
$templatesDir = Join-Path $projectRoot "templates"

# 🌐 إعدادات الموقع
$baseUrl = "https://sfnzai.github.io/PROTOCORE"
$languages = @("en", "fr", "ar", "es", "zh")
$defaultLang = "en"

# 📅 التاريخ الحالي
$now = Get-Date
$year = $now.ToString("yyyy")
$month = $now.ToString("MM")
$day = $now.ToString("dd")
$dateStamp = $now.ToString("yyyyMMdd")

# 🧠 إعدادات الإشارة
$topicsPath = Join-Path $projectRoot "topics.txt"
$signalPrompt = "Generate a multilingual signal about '{topic}' with context, insight, recommendation, and reflection, across 5 languages."