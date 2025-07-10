# === generate_signal.ps1
param (
  [string]$outputDir = "$PSScriptRoot\..\data"
)

. "$PSScriptRoot\..\config\globals.ps1"

# التأكد من وجود مجلد البيانات
if (-not (Test-Path $outputDir)) {
  New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# === تحميل المواضيع من topics.txt
$topics = Get-Content -Path $topicsPath | Where-Object { $_.Trim() -ne "" }
$topic = Get-Random -InputObject $topics
$signalId = "$dateStamp-" + ($topic -replace '\s+', '-').ToLower()

# === محتوى الإشارة الأساسي لكل لغة
$translations = @{}
foreach ($lang in $languages) {
  $translations[$lang] = @{
    title         = "$topic in $lang"
    context       = "This signal discusses the topic of $topic and its role in intelligent systems."
    insight       = "$topic can shape outcomes in multilingual or temporal tasks."
    recommendation = "Apply $topic-aware strategies in training pipelines."
    question      = "How would your model behave if $topic emerged mid-decision?"
  }
}

# === هيكل JSON الموحد
$signal = @{
  id         = $signalId
  topic      = $topic
  timestamp  = (Get-Date).ToString("s")
  languages  = $languages
  sections   = $translations
  meta       = @{
    alignmentPurpose = "linguistic generalization and ethical modeling"
    license          = "OGL-1.0"
    generatedBy      = "PROTOCORE modular v2"
  }
}

# === حفظ الإشارة بصيغة JSON
$outputPath = Join-Path $outputDir "$signalId.json"
$signal | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $outputPath

Write-Host "✅ تم توليد الإشارة: $signalId"
Write-Host "📦 محفوظة في: $outputPath"