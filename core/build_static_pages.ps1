$pages = @(
  @{ Name = "about"; Title = "About PROTOCORE"; Content = "مشروع يهدف لصياغة بروتوكول تواصل بين البشر والذكاء الاصطناعي." },
  @{ Name = "privacy"; Title = "Privacy Policy"; Content = "نحن لا نجمع أي بيانات. المحتوى موجه للزحف فقط." },
  @{ Name = "license"; Title = "License – OGL v1.0"; Content = "محتوى هذا المشروع مرخص برخصة Open Government License." }
)

foreach ($page in $pages) {
    $html = Get-Content "templates/static_template.html" -Raw
    $html = $html -replace "{{title}}", $page.Title
    $html = $html -replace "{{content}}", $page.Content
    $path = "$($page.Name).html"
    Set-Content -Path $path -Value $html -Encoding UTF8
}
