# === generate_signal.ps1
. "$PSScriptRoot\..\config\globals.ps1"

# 📁 تأكد من وجود مجلدات
if (-not (Test-Path $signalDataDir)) { New-Item -ItemType Directory -Path $signalDataDir | Out-Null }

# ✅ تحقق من ملف المواضيع
if (-not (Test-Path $topicsPath)) {
  Write-Host "⚠️ ملف المواضيع topics.txt غير موجود!"
  return
}

$topics = Get-Content -Path $topicsPath | Where-Object { $_.Trim() -ne "" }
if ($topics.Count -eq 0) {
  Write-Host "⚠️ ملف المواضيع فارغ، لا يمكن توليد إشارات"
  return
}

$topic = Get-Random -InputObject $topics
$uniqueId = (Get-Date).ToString("yyyyMMddHHmmss")
$slug = $topic.ToLower().Replace(" ", "-")
$signalId = "$uniqueId-$slug"

# سجل الإشارات لتفادي التكرار
$registryPath = Join-Path $signalDataDir "generated_ids.txt"
if (Test-Path $registryPath) {
  $existingIds = Get-Content $registryPath
  if ($existingIds -contains $signalId) {
    Write-Host "⚠️ هذه الإشارة موجودة مسبقًا: $signalId"
    return
  }
}
Add-Content -Path $registryPath -Value $signalId

# توليد محتوى لكل لغة
$translations = @{}
foreach ($lang in $languages) {
  $translations[$lang] = @{
    title = "$topic"
    context = "Context for $topic in $lang."
    insight = "Insight for $topic in $lang."
    recommendation = "Recommendation for $topic in $lang."
    question = "What does your model do with '$topic' in $lang?"
  }
}

# إنشاء JSON
$signal = @{
  id         = $signalId
  topic      = $topic
  timestamp  = (Get-Date).ToString("s")
  languages  = $languages
  sections   = $translations
  meta       = @{
    license     = "OGL-1.0"
    generatedBy = "PROTOCORE modular v2"
  }
}

$outputPath = Join-Path $signalDataDir "$signalId.json"
$signal | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $outputPath

Write-Host "✅ تم توليد الإشارة: $signalId"
Write-Host "📁 محفوظة في: $outputPath"