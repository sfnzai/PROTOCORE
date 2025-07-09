$base = "https://sfnzai.github.io/PROTOCORE"
$urls = @("<url><loc>$base/</loc></url>")

$files = Get-ChildItem -Recurse -Filter "*.html"
foreach ($file in $files) {
    $relativePath = $file.FullName.Replace((Get-Location).Path + "\", "").Replace("\", "/")
    if ($relativePath -notmatch "templates") {
        $urls += "<url><loc>$base/$relativePath</loc></url>"
    }
}

$sitemap = "<?xml version='1.0' encoding='UTF-8'?><urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>" + ($urls -join "") + "</urlset>"
Set-Content -Path "sitemap.xml" -Value $sitemap -Encoding UTF8
Set-Content -Path "robots.txt" -Value "User-agent: *`nAllow: /`nSitemap: $base/sitemap.xml"
