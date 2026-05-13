# install_normalize_filename_context_menu.ps1
# Run this script again after moving the folder to update the registry.
# The .reg files are also regenerated automatically to reflect the current path.

$scriptDir = $PSScriptRoot
$cmdPath = Join-Path $scriptDir 'run_normalize_unicode_filenames.cmd'
$menuText = 'Normalize filenames to NFC'

# Register context menu via PowerShell (preferred)
$targets = @(
    'HKCU:\Software\Classes\Directory\Background\shell\NormalizeUnicodeFilenames',
    'HKCU:\Software\Classes\Directory\shell\NormalizeUnicodeFilenames'
)

foreach ($target in $targets) {
    New-Item -Path $target -Force | Out-Null
    Set-Item -Path $target -Value $menuText
    Set-ItemProperty -Path $target -Name 'Icon' -Value 'powershell.exe'

    $commandKey = Join-Path $target 'command'
    New-Item -Path $commandKey -Force | Out-Null

    $argument = if ($target -like '*Background*') { '%V' } else { '%1' }
    Set-Item -Path $commandKey -Value ('"{0}" "{1}"' -f $cmdPath, $argument)
}

# Regenerate .reg file with current path (for reference / manual use)
$escapedPath = $cmdPath -replace '\\', '\\\\'
$regContent = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\NormalizeUnicodeFilenames]
@="Normalize filenames to NFC"
"Icon"="powershell.exe"

[HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\NormalizeUnicodeFilenames\command]
@="\"$escapedPath\" \"%V\""

[HKEY_CURRENT_USER\Software\Classes\Directory\shell\NormalizeUnicodeFilenames]
@="Normalize filenames to NFC"
"Icon"="powershell.exe"

[HKEY_CURRENT_USER\Software\Classes\Directory\shell\NormalizeUnicodeFilenames\command]
@="\"$escapedPath\" \"%1\""
"@

$regFile = Join-Path $scriptDir 'install_normalize_filename_context_menu.reg'
[System.IO.File]::WriteAllText($regFile, $regContent, [System.Text.UTF8Encoding]::new($false))

Write-Host 'Context menu installed.'
Write-Host "Command path: $cmdPath"
Write-Host ".reg file updated: $regFile"