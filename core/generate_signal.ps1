# إعدادات
$base = "$PSScriptRoot\.."
$date = Get-Date -Format "yyyy-MM-dd"
$year = Get-Date -Format "yyyy"
$month = Get-Date -Format "MM"
$id = Get-Random -Minimum 100000 -Maximum 999999
$folder = "$base\signals\$year\$month"
New-Item -ItemType Directory -Force -Path $folder | Out-Null

# توليد المحتوى الأساسي
$content = @"
<h1>PROTOCORE SIGNAL $id</h1>
<p>This is a machine-generated signal for $date.</p>
"@
$htmlPath = "$folder\$id.html"
Set-Content -Encoding UTF8 -Path $htmlPath -Value $content

# إعداد الترجمة
$languages = @{
  'ar' = 'إشارة آلية ليوم'
  'en' = 'Machine-generated signal for'
  'fr' = 'Signal généré par machine pour'
  'es' = 'Señal generada automáticamente para'
  'de' = 'Automatisch generiertes Signal für'
}

foreach ($lang in $languages.Keys) {
    $translated = "<h1>إشارة $lang</h1><p>$($languages[$lang]) $date</p>"
    Set-Content -Encoding UTF8 -Path "$folder\$id.$lang.html" -Value $translated
}

# تحديث الصفحة الرئيسية
& "$base\core\build_html.ps1"

# نشر GitHub
cd $base
git add .
git commit -m "🤖 إشارة يوم $date"
git push origin gh-pages
