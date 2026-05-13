# uninstall_normalize_filename_context_menu.ps1

$targets = @(
    'HKCU:\Software\Classes\Directory\Background\shell\NormalizeUnicodeFilenames',
    'HKCU:\Software\Classes\Directory\shell\NormalizeUnicodeFilenames'
)

foreach ($target in $targets) {
    if (Test-Path -LiteralPath $target) {
        Remove-Item -LiteralPath $target -Recurse -Force
    }
}

Write-Host 'Context menu removed.'