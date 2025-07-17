// === PROTOCORE FINAL / signal.js

function copySignal(btn) {
  const block = btn.closest(".signal-block");
  const text = block.innerText;
  navigator.clipboard.writeText(text).then(() => {
    alert("✅ Signal copied!");
  });
}

function shareSignal(btn) {
  const url = window.location.href;
  const title = document.title;
  const tweetText = `Explore this PROTOCORE signal: ${title}`;
  const tweetUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(tweetText)}&url=${encodeURIComponent(url)}`;
  window.open(tweetUrl, "_blank");
}

function downloadJSON() {
  const jsonUrl = window.location.href.replace(".html", ".json");
  window.open(jsonUrl, "_blank");
}