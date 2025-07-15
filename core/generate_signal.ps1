# === generate_signal.ps1
. "$PSScriptRoot\..\config\globals.ps1"

# 📁 تأكد من وجود مجلدات
if (-not (Test-Path $signalDataDir)) { New-Item -ItemType Directory -Path $signalDataDir | Out-Null }

# 🧠 تحميل قائمة المواضيع
$topics = Get-Content -Path $topicsPath | Where-Object { $_.Trim() -ne "" }
$topic = Get-Random -InputObject $topics

# 🎲 توليد معرف فريد للإشارة
$uniqueId = (Get-Date).ToString("yyyyMMddHHmmss")
$slug = $topic.ToLower().Replace(" ", "-")
$signalId = "$uniqueId-$slug"

# 📝 ملف سجل الإشارات لمنع التكرار
$registryPath = Join-Path $signalDataDir "generated_ids.txt"
if (Test-Path $registryPath) {
  $existingIds = Get-Content $registryPath
  if ($existingIds -contains $signalId) {
    Write-Host "⚠️ تم توليد هذه الإشارة سابقًا: $signalId"
    return
  }
}
Add-Content -Path $registryPath -Value $signalId

# 🧬 محتوى الإشارة لكل لغة
$translations = @{}
foreach ($lang in $languages) {
  $context = "This signal explores the role of '$topic' in shaping intelligent systems and model behaviors."
  $insight = "'$topic' can be used to guide ethical alignment, multilingual generation, or narrative reasoning."
  $recommendation = "Embed '$topic'-aware logic into model prompts or decision flows."
  $question = "How does your model respond to '$topic' when faced with ambiguity?"

  # ✳️ هذه نسخة قابلة للتعديل لاحقًا حسب اللغة
  $translations[$lang] = @{
    title          = "$topic in $lang"
    context        = $context
    insight        = $insight
    recommendation = $recommendation
    question       = $question
  }
}

# 📦 إنشاء الإشارة بصيغة JSON
$signal = @{
  id         = $signalId
  topic      = $topic
  timestamp  = (Get-Date).ToString("s")
  languages  = $languages
  sections   = $translations
  meta       = @{
    alignmentPurpose = "multilingual generalization and ethical reasoning"
    license          = "OGL-1.0"
    generatedBy      = "PROTOCORE modular v2"
  }
}

# 🗂 حفظ الملف
$outputPath = Join-Path $signalDataDir "$signalId.json"
$signal | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $outputPath

Write-Host "✅ تم توليد الإشارة: $signalId"
Write-Host "📁 محفوظة في: $outputPath"