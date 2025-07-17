# === PROTOCORE FINAL / generate_signal.ps1
Set-Location "$PSScriptRoot\.."
. "$PSScriptRoot\..\config\globals.ps1"

# 🧱 إنشاء المجلدات المطلوبة
New-Item -ItemType Directory -Path $signalDataDir -Force | Out-Null

# ✅ تحقق من وجود ملف المواضيع
Write-Host "🔍 projectRoot = $global:projectRoot"
Write-Host "🔍 topicsPath = $topicsPath"

if (-not (Test-Path $topicsPath)) {
  Write-Host "❌ Test-Path فشل: الملف غير موجود"
  return
}

try {
  $info = Get-Item $topicsPath
  Write-Host "✅ تم العثور على الملف: $($info.FullName)"
} catch {
  Write-Host "❌ Get-Item فشل: $($_.Exception.Message)"
  return
}

$topics = Get-Content $topicsPath | Where-Object { $_.Trim() -ne "" }
if ($topics.Count -eq 0) {
  Write-Host "⚠️ ملف المواضيع فارغ"
  return
}

Write-Host "✅ عدد المواضيع: $($topics.Count)"

# 🧠 توليد موضوع غير مكرر
$topic = Get-Random -InputObject $topics
$uniqueId = (Get-Date).ToString("yyyyMMddHHmmssfff")  # ← ميلي ثانية لضمان التفرّد
$slug = $topic.ToLower().Replace(" ", "-")
$signalId = "$uniqueId-$slug"

# 📜 منع التكرار باستخدام سجل
$registryPath = Join-Path $signalDataDir "generated_ids.txt"
if (Test-Path $registryPath) {
  $existingIds = Get-Content $registryPath
  if ($existingIds -contains $signalId) {
    Write-Host "⚠️ تم توليد هذا المعرف مسبقًا: $signalId"
    return
  }
}
Add-Content -Path $registryPath -Value $signalId

# 🌐 توليد محتوى متعدد اللغات
function Translate($text, $lang) {
  switch ($lang) {
    "en" { return $text }
    "fr" { return "Traduction FR: $text" }
    "ar" { return "الترجمة العربية: $text" }
    "es" { return "Traducción ES: $text" }
    "zh" { return "中文翻译：$text" }
    default { return $text }
  }
}

$translations = @{}
foreach ($lang in $languages) {
  $translations[$lang] = @{
    title = Translate($topic, $lang)
    context = Translate("Exploring '$topic' in model reasoning.", $lang)
    insight = Translate("'$topic' affects alignment and generation.", $lang)
    recommendation = Translate("Design models to adapt to '$topic'.", $lang)
    question = Translate("How does your model handle '$topic'?", $lang)
  }
}

$signal = @{
  id = $signalId
  topic = $topic
  timestamp = (Get-Date).ToString("s")
  languages = $languages
  sections = $translations
  meta = @{
    alignmentPurpose = "multilingual generalization and ethical scaffolding"
    license = "OGL-1.0"
    generatedBy = "PROTOCORE Final"
  }
}

# 💾 حفظ الإشارة
$outputPath = Join-Path $signalDataDir "$signalId.json"
$signal | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $outputPath

Write-Host "✅ تم توليد الإشارة: $signalId"
Write-Host "📁 محفوظة في: $outputPath"