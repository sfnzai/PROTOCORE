function showTab(id) {
  let contents = document.querySelectorAll(".tab-content");
  contents.forEach(c => c.style.display = "none");
  document.getElementById(id).style.display = "block";
}
window.onload = function () {
  let first = document.querySelector(".tab-content");
  if (first) first.style.display = "block";
};
