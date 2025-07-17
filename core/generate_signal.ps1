Set-Location "$PSScriptRoot\.."
. "$PSScriptRoot\..\config\globals.ps1"

Write-Host "🔍 projectRoot = $projectRoot"
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