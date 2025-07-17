# توليد إشارة متعددة اللغات بمحتوى فعلي
. "$PSScriptRoot\..\config\globals.ps1"

New-Item -ItemType Directory -Path $signalDataDir -Force | Out-Null

if (-not (Test-Path $topicsPath)) { Write-Host "⚠️ ملف المواضيع غير موجود"; return }
$topics = Get-Content $topicsPath | Where-Object { $_.Trim() -ne "" }
if ($topics.Count -eq 0) { Write-Host "⚠️ ملف المواضيع فارغ"; return }

$topic = Get-Random -InputObject $topics
$uniqueId = (Get-Date).ToString("yyyyMMddHHmmss")
$slug = $topic.ToLower().Replace(" ", "-")
$signalId = "$uniqueId-$slug"

$registryPath = Join-Path $signalDataDir "generated_ids.txt"
if (Test-Path $registryPath) {
  $existingIds = Get-Content $registryPath
  if ($existingIds -contains $signalId) { Write-Host "⚠️ مكرر"; return }
}
Add-Content -Path $registryPath -Value $signalId

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

$outputPath = Join-Path $signalDataDir "$signalId.json"
$signal | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $outputPath
Write-Host "✅ تم توليد الإشارة: $signalId"