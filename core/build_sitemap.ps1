# === build_sitemap.ps1
. "$PSScriptRoot\..\config\globals.ps1"

$pages = Get-ChildItem -Path "$projectRoot" -Recurse -Include *.html | Sort-Object FullName

$sitemap = @()
$sitemap += '<?xml version="1.0" encoding="UTF-8"?>'
$sitemap += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'

foreach ($file in $pages) {
  $rel = $file.FullName.Replace($projectRoot, "").Replace("\", "/").TrimStart("/")
  $url = "$baseUrl/$rel"
  $lastmod = (Get-Date $file.LastWriteTimeUtc -Format "yyyy-MM-dd")
  $sitemap += "  <url><loc>$url</loc><lastmod>$lastmod</lastmod></url>"
}

$sitemap += '</urlset>'
$sitemapPath = Join-Path $projectRoot "sitemap.xml"
$sitemap -join "`n" | Out-File -Encoding UTF8 $sitemapPath
Write-Host "✅ تم إنشاء sitemap.xml"

# === robots.txt
$robots = @"
User-agent: *
Allow: /

Sitemap: $baseUrl/sitemap.xml
"@
$robotsPath = Join-Path $projectRoot "robots.txt"
$robots | Out-File -Encoding UTF8 $robotsPath
Write-Host "✅ تم إنشاء robots.txt"