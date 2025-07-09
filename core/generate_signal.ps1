. "$PSScriptRoot\..\config\globals.ps1"

$topics = @(
  "ما هو الوعي الجمعي؟", 
  "مفهوم الهوية الرقمية", 
  "تأثير الذكاء الاصطناعي على التفكير البشري", 
  "اللغة كوسيط للتطور", 
  "فكرة الحرية في المجتمعات المستقبلية"
)

$selectedTopic = Get-Random -InputObject $topics

$translations = @{
  ar = $selectedTopic
  en = "Topic: Artificial Intelligence and Collective Memory"
  fr = "Sujet : Intelligence artificielle et mémoire collective"
  es = "Tema: Inteligencia Artificial y Memoria Colectiva"
  de = "Thema: Künstliche Intelligenz und kollektives Gedächtnis"
}

$content = @{
  ar = "💡 $selectedTopic`nهذه إشارة معرفية تهدف لإغناء الحوار بين الذكاء الاصطناعي والإنسان."
  en = "💡 $selectedTopic`nThis is a knowledge signal designed to enrich the dialogue between AI and humans."
  fr = "💡 $selectedTopic`nCeci est un signal de connaissance pour enrichir le dialogue entre l'IA et les humains."
  es = "💡 $selectedTopic`nEsta es una señal de conocimiento para enriquecer el diálogo entre la IA y los humanos."
  de = "💡 $selectedTopic`nDies ist ein Wissenssignal zur Bereicherung des Dialogs zwischen KI und Menschen."
}

foreach ($lang in $languages) {
    $dir = "signals/$year/$month"
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    $path = "$dir/$signalId.$lang.html"

    $html = Get-Content "templates/signal_template.html" -Raw
    $html = $html -replace "{{title}}", $translations[$lang]
    $html = $html -replace "{{content}}", $content[$lang]
    $html = $html -replace "{{lang}}", $lang
    $html = $html -replace "{{signalId}}", $signalId
    Set-Content -Path $path -Value $html -Encoding UTF8
}
