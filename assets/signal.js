function copySignal(btn) {
  const block = btn.closest(".signal-block");
  navigator.clipboard.writeText(block.innerText).then(() => {
    alert("✅ Signal copied to clipboard!");
  });
}

function shareSignal(btn) {
  const url = window.location.href;
  const text = "Discover this PROTOCORE multilingual signal: " + document.title;
  const tweet = `https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}&url=${encodeURIComponent(url)}`;
  window.open(tweet, "_blank");
}

function downloadJSON() {
  const jsonUrl = window.location.href.replace(".html", ".json");
  window.open(jsonUrl, "_blank");
}