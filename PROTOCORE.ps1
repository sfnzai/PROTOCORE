<#
.NOTES
    PROTOCORE - الإصدار النهائي المؤكد
    تم إصلاح جميع مشاكل المسارات والتواريخ
#>

# === الإعدادات الأساسية ===
$global:PROJECT_ROOT = Join-Path $env:USERPROFILE "Desktop\protocore"
$global:REPO_URL = "https://github.com/sfnzai/PROTOCORE.git"
$global:BASE_URL = "https://sfnzai.github.io/PROTOCORE"

# === تهيئة المشروع ===
function Initialize-Project {
    # إنشاء المجلد الرئيسي إذا لم يكن موجوداً
    if (-not (Test-Path $global:PROJECT_ROOT)) {
        New-Item -ItemType Directory -Path $global:PROJECT_ROOT -Force | Out-Null
    }

    # إنشاء مجلد الإشارات
    $signalsDir = Join-Path $global:PROJECT_ROOT "signals"
    if (-not (Test-Path $signalsDir)) {
        New-Item -ItemType Directory -Path $signalsDir -Force | Out-Null
    }

    # تهيئة مستودع Git
    if (-not (Test-Path (Join-Path $global:PROJECT_ROOT ".git"))) {
        Set-Location $global:PROJECT_ROOT
        git init
        git remote add origin $global:REPO_URL
        git checkout -b gh-pages
    }
}

# === توليد إشارة جديدة ===
function Generate-Signal {
    $currentDate = Get-Date
    $signalId = "SGN-" + $currentDate.ToString("yyyyMMddHHmmss")
    
    return [PSCustomObject]@{
        SignalId = $signalId
        Date = $currentDate.ToString("yyyy-MM-dd")
        Content = @{
            "en" = "Quantum communication protocol established."
            "ar" = "تم إنشاء بروتوكول اتصال كمي."
        }
        Metadata = @{
            License = "CC BY-NC-SA 4.0"
            Timestamp = $currentDate.ToUniversalTime().ToString("o")
        }
    }
}

# === إنشاء صفحة الإشارة ===
function Create-SignalPage {
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Signal
    )

    $fileName = "$($Signal.Date).html"
    $signalPath = Join-Path -Path (Join-Path $global:PROJECT_ROOT "signals") -ChildPath $fileName
    
    $htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PROTOCORE Signal - $($Signal.Date)</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            background: #0a0a0a;
            color: #e0e0e0;
            padding: 20px;
            line-height: 1.6;
        }
        .signal-container {
            background: #121212;
            padding: 20px;
            border-radius: 5px;
            max-width: 800px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <div class="signal-container">
        <h1>PROTOCORE SIGNAL</h1>
        <p><strong>Date:</strong> $($Signal.Date)</p>
        <p><strong>Signal ID:</strong> $($Signal.SignalId)</p>
        <p><strong>Content (EN):</strong> $($Signal.Content['en'])</p>
        <p><strong>Content (AR):</strong> $($Signal.Content['ar'])</p>
        <p><strong>License:</strong> $($Signal.Metadata.License)</p>
        <p><strong>Timestamp:</strong> $($Signal.Metadata.Timestamp)</p>
    </div>
</body>
</html>
"@

    try {
        $htmlContent | Out-File -FilePath $signalPath -Encoding UTF8 -Force
        return $signalPath
    }
    catch {
        Write-Error "Failed to create signal page: $_"
        return $null
    }
}

# === التزامن مع GitHub ===
function Sync-WithGitHub {
    try {
        Set-Location $global:PROJECT_ROOT
        git add .
        git commit -m "Update: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        git push origin gh-pages
        return $true
    }
    catch {
        Write-Error "Failed to sync with GitHub: $_"
        return $false
    }
}

# === التنفيذ الرئيسي ===
try {
    Write-Host "بدء تشغيل بروتوكول PROTOCORE..." -ForegroundColor Cyan

    # 1. التهيئة
    Initialize-Project

    # 2. توليد الإشارة
    $signal = Generate-Signal
    Write-Host "تم توليد إشارة جديدة: $($signal.SignalId)" -ForegroundColor Yellow

    # 3. إنشاء صفحة الإشارة
    $signalPath = Create-SignalPage -Signal $signal
    if (-not $signalPath) {
        throw "فشل في إنشاء صفحة الإشارة"
    }
    Write-Host "تم إنشاء صفحة الإشارة: $signalPath" -ForegroundColor Yellow

    # 4. المزامنة مع GitHub
    $syncResult = Sync-WithGitHub
    if (-not $syncResult) {
        throw "فشل في المزامنة مع GitHub"
    }

    Write-Host @"
=== تم تنفيذ البروتوكول بنجاح ===
🆔 معرف الإشارة: $($signal.SignalId)
📅 التاريخ: $($signal.Date)
📂 مسار الملف: $signalPath
🌐 عنوان الموقع: $global:BASE_URL
"@ -ForegroundColor Green
}
catch {
    Write-Host "حدث خطأ في التنفيذ: $_" -ForegroundColor Red
    exit 1
}