Set-Location "$PSScriptRoot\.."
. "$PSScriptRoot\..\config\globals.ps1"

New-Item -ItemType Directory -Path $signalDataDir -Force | Out-Null

$topics = Get-Content $topicsPath | Where-Object { $_.Trim() -ne "" }
if ($topics.Count -eq 0) {
  Write-Host "⚠️ ملف المواضيع فارغ"
  return
}

$topic = "$(Get-Random -InputObject $topics)"
Write-Host "🧠 الموضوع المختار: $topic"

$uniqueId = (Get-Date).ToString("yyyyMMddHHmmssfff")
$slug = $topic.ToLower().Replace(" ", "-")
$signalId = "$uniqueId-$slug"

$registryPath = Join-Path $signalDataDir "generated_ids.txt"
if (Test-Path $registryPath) {
  $existingIds = Get-Content $registryPath
  if ($existingIds -contains $signalId) {
    Write-Host "⚠️ تم توليد هذا المعرف مسبقًا: $signalId"
    return
  }
}
Add-Content -Path $registryPath -Value $signalId

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

$contextText = "Exploring '$topic' in model reasoning."
$insightText = "'$topic' affects alignment and generation."
$recommendationText = "Design models to adapt to '$topic'."
$questionText = "How does your model handle '$topic'?"

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
Write-Host "📁 محفوظة في: $outputPath"