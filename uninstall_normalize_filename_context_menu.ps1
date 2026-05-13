# uninstall_normalize_filename_context_menu.ps1

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$targets = @(
    'HKCU:\Software\Classes\Directory\Background\shell\NormalizeUnicodeFilenames',
    'HKCU:\Software\Classes\Directory\shell\NormalizeUnicodeFilenames'
)

foreach ($target in $targets) {
    if (Test-Path -LiteralPath $target) {
        Remove-Item -LiteralPath $target -Recurse -Force
    }
}

$installRoot = Join-Path $env:LOCALAPPDATA 'UnicodeFilenameTools'
if (Test-Path -LiteralPath $installRoot) {
    Remove-Item -LiteralPath $installRoot -Recurse -Force
}

Write-Host 'Context menu removed.'
Write-Host "Removed install folder: $installRoot"