# Define directories and filenames
$baseDir = "C:\Users\$env:USERNAME\Desktop\protocore"
$signalDir = "$baseDir\signals"
$pages = @("index.html", "about.html", "support.html", "privacy.html", "terms.html", "license.html", "contact.html", "donate.html")

# Create necessary directories
New-Item -ItemType Directory -Force -Path $signalDir

# Function to generate a unique slug for each signal
Function Generate-Slug($title) {
    return $title -replace '[^\w\s-]', '' -replace ' ', '-'
}

# Function to generate content for each language
Function Generate-Content($language) {
    # Generate dummy content for each language
    return @{
        context = "This is context for $language."
        insight = "This is insight for $language."
        recommendation = "This is recommendation for $language."
        question = "What do you think about this in $language?"
    }
}

# Create the static pages
foreach ($page in $pages) {
    $filePath = "$baseDir\$page"
    Set-Content -Path $filePath -Value "<html><head><title>$page</title></head><body><h1>$page</h1><p>Content for $page</p></body></html>"
}

# Generate signal files
$date = Get-Date -Format "yyyy/MM/dd"
$signalPath = "$signalDir\$date.html"
New-Item -ItemType File -Force -Path $signalPath

$slug = Generate-Slug "Sample Signal Title"
$signalContent = Generate-Content "en"
Set-Content -Path $signalPath -Value "<html><head><title>$slug</title></head><body><h1>$slug</h1><p>$($signalContent.context)</p><p>$($signalContent.insight)</p><p>$($signalContent.recommendation)</p><p>$($signalContent.question)</p></body></html>"

# Update sitemap.xml and robots.txt
$sitemapPath = "$baseDir\sitemap.xml"
$robotsPath = "$baseDir\robots.txt"

# Example: Update sitemap
Set-Content -Path $sitemapPath -Value "<url><loc>https://sfnzai.github.io/PROTOCORE/</loc><lastmod>$(Get-Date -Format 'yyyy-MM-dd')</lastmod></url>"

# GitHub push commands
cd $baseDir
git add .
git commit -m "🔁 Auto-update signal + multilingual archive"
git push origin gh-pages
