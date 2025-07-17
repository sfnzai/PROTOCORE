# === PROTOCORE FINAL / run.ps1

# 🧭 تحديد الجذر الحقيقي للمشروع
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition

# 📦 تمرير المسار إلى كل السكربتات
. "$projectRoot\config\globals.ps1"
$global:projectRoot = $projectRoot

. "$projectRoot\core\generate_signal.ps1"
. "$projectRoot\core\build_html.ps1"
. "$projectRoot\core\build_archive.ps1"
. "$projectRoot\core\build_static_pages.ps1"
. "$projectRoot\core\build_sitemap.ps1"
. "$projectRoot\core\deploy.ps1"