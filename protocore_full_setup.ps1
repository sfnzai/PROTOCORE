# === الانتقال إلى مجلد المشروع
Set-Location $projectRoot

# === التأكد من وجود git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Error "❌ Git غير مثبت أو غير مفعل في النظام."
  exit
}

# === التأكد من تهيئة المستودع
if (-not (Test-Path ".git")) {
  git init
  git branch -M gh-pages
  git remote add origin https://github.com/sfnzai/PROTOCORE.git
}

# === إضافة جميع الملفات
git add .

# === إنشاء رسالة commit ديناميكية
$commitMessage = "🔁 Auto-update signal + multilingual archive - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"

# === تنفيذ commit
git commit -m "$commitMessage"

# === دفع التحديثات إلى GitHub
git push origin gh-pages

Write-Host "✅ تم رفع التحديثات إلى GitHub Pages بنجاح"