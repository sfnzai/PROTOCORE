# === deploy.ps1
. "$PSScriptRoot\..\config\globals.ps1"

# تأكد من المسار الصحيح
Set-Location $projectRoot

# Git خطوات النشر
git add .
$commitMessage = "🛰️ Auto-deploy PROTOCORE update - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git commit -m "$commitMessage"
git push origin gh-pages

Write-Host "✅ تم نشر الموقع على GitHub Pages بنجاح"