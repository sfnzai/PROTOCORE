$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $scriptRoot

. "config/globals.ps1"
. "core/generate_signal.ps1"
. "core/build_html.ps1"
. "core/build_archive.ps1"
. "core/build_static_pages.ps1"
. "core/build_sitemap.ps1"
. "core/deploy.ps1"