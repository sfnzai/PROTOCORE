. "$PSScriptRoot\..\config\globals.ps1"

$dir = "signals/$year/$month"
$signalFiles = Get-ChildItem "$dir/$signalId.*.html"

$combinedHtml = "<!DOCTYPE html>`n<html lang='en'>`n<head>`n"
$combinedHtml += "<meta charset='UTF-8'>`n"
$combinedHtml += "<meta name='viewport' content='width=device-width, initial-scale=1.0'>`n"
$combinedHtml += "<title>PROTOCORE Signal $signalId</title>`n"
$combinedHtml += "<link rel='stylesheet' href='../../assets/style.css'>`n"
$combinedHtml += "<script src='../../assets/signal.js'></script>`n"
$combinedHtml += "</head><body>`n"

$combinedHtml += "<nav><h1>PROTOCORE Signal $signalId</h1></nav>`n"
$combinedHtml += "<div class='tabs'>`n"

foreach ($lang in $languages) {
    $tabId = "tab-$lang"
    $combinedHtml += "<button onclick=""showTab('$tabId')"">$lang</button>`n"
}
$combinedHtml += "</div><div class='content'>`n"

foreach ($lang in $languages) {
    $path = "$dir/$signalId.$lang.html"
    $html = Get-Content $path -Raw
    $combinedHtml += "<div id='tab-$lang' class='tab-content' style='display:none;'>`n$html`n</div>`n"
}

$combinedHtml += "</div>`n"
$combinedHtml += "<footer>© PROTOCORE | Multilingual Cognitive Signals</footer>`n"
$combinedHtml += "</body></html>"

$finalPath = "$dir/$signalId.html"
Set-Content -Path $finalPath -Value $combinedHtml -Encoding UTF8

git push origin gh-pages
