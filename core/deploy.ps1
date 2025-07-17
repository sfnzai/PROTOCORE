# === PROTOCORE FINAL / deploy.ps1
. "$PSScriptRoot\..\config\globals.ps1"

Set-Location $projectRoot

# 🕒 تعديل طفيف لإجبار Git على التحديث
$dateStamp = Get-Date -Format "yyyy-MM-dd HH:mm"
"Build deployed at $dateStamp" | Out-File "$projectRoot\build_log.txt"

# 🚀 Git أوامر النشر
git add .
$commitMessage = "🛰️ PROTOCORE Final Deploy — $dateStamp"
git commit -m "$commitMessage"
git push origin gh-pages

Write-Host "✅ تم نشر جميع التحديثات إلى GitHub Pages بنجاح"