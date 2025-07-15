function copySignal(btn) {
  const block = btn.closest(".signal-block");
  const text = block.innerText;
  navigator.clipboard.writeText(text).then(() => {
    alert("✅ Signal copied to clipboard!");
  });
}

function shareSignal(btn) {
  const url = window.location.href;
  const title = document.title;
  const tweetText = `Discover this PROTOCORE signal: ${title}`;
  const tweetURL = `https://twitter.com/intent/tweet?text=${encodeURIComponent(tweetText)}&url=${encodeURIComponent(url)}`;
  window.open(tweetURL, "_blank");
}

function downloadJSON() {
  const jsonUrl = window.location.href.replace(".html", ".json");
  window.open(jsonUrl, "_blank");
}