# === PROTOCORE FINAL / generate_signal.ps1
Set-Location "$PSScriptRoot\.."
. "$PSScriptRoot\..\config\globals.ps1"

# 🧱 إنشاء المجلدات المطلوبة
New-Item -ItemType Directory -Path $signalDataDir -Force | Out-Null

# ✅ تحقق من وجود ملف المواضيع
Write-Host "🔍 projectRoot = $global:projectRoot"
Write-Host "🔍 topicsPath = $topicsPath"

if (-not (Test-Path $topicsPath)) {
  Write-Host "❌ ملف المواضيع غير موجود"
  return
}

$topics = Get-Content $topicsPath | Where-Object { $_.Trim() -ne "" }
if ($topics.Count -eq 0) {
  Write-Host "⚠️ ملف المواضيع فارغ"
  return
}

Write-Host "✅ عدد المواضيع: $($topics.Count)"

# 🧠 توليد موضوع غير مكرر
$topic = "$(Get-Random -InputObject $topics)"
Write-Host "🧠 الموضوع المختار: $topic"

$uniqueId = (Get-Date).ToString("yyyyMMddHHmmssfff")
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

# 🌐 دالة الترجمة
function Translate($text, $lang) {
  if (-not $text) { return "[No content]" }
  switch ($lang) {
    "en" { return $text }
    "fr" { return "FR: $text" }
    "ar" { return "AR: $text" }
    "es" { return "ES: $text" }
    "zh" { return "ZH: $text" }
    default { return $text }
  }
}

# 🧩 محتوى الإشارة
$contextText = "Exploring '$topic' in model reasoning."
$insightText = "'$topic' affects alignment and generation."
$recommendationText = "Design models to adapt to '$topic'."
$questionText = "How does your model handle '$topic'?"

Write-Host "🧩 Context: $contextText"
Write-Host "🔍 Insight: $insightText"
Write-Host "⚙️ Recommendation: $recommendationText"
Write-Host "🤔 Question: $questionText"

# 🌐 توليد ترجمات
$translations = @{}
foreach ($lang in $languages) {
  $translations[$lang] = @{
    title = Translate($topic, $lang)
    context = Translate($contextText, $lang)
    insight = Translate($insightText, $lang)
    recommendation = Translate($recommendationText, $lang)
    question = Translate($questionText, $lang)
  }
}

# 📦 بناء الإشارة
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