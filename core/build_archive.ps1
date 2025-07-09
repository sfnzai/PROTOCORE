$indexContent = "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'>"
$indexContent += "<title>PROTOCORE Archive</title><link rel='stylesheet' href='assets/style.css'>"
$indexContent += "</head><body><h1>📚 PROTOCORE Archive</h1><ul>"

$folders = Get-ChildItem -Path "signals" -Recurse -Directory

foreach ($folder in $folders) {
    $files = Get-ChildItem -Path $folder.FullName -Filter "*.html" | Where-Object { $_.Name -notmatch "\.[a-z]{2}\.html$" }
    foreach ($file in $files) {
        $relativePath = $file.FullName.Replace((Get-Location).Path + "\", "").Replace("\", "/")
        $indexContent += "<li><a href='$relativePath'>🔗 Signal $($file.BaseName)</a></li>"
    }
}

$indexContent += "</ul><footer>PROTOCORE | Signals to train your mind and models 🧠</footer></body></html>"

Set-Content -Path "index.html" -Value $indexContent -Encoding UTF8
