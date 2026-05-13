# install_normalize_filename_context_menu.ps1
# Portable-safe install: scripts are copied to %LOCALAPPDATA% and registry points there.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = $PSScriptRoot
$menuText = 'Normalize filenames to NFC'

$installRoot = Join-Path $env:LOCALAPPDATA 'UnicodeFilenameTools'
New-Item -ItemType Directory -Path $installRoot -Force | Out-Null

$sourceCmd = Join-Path $scriptDir 'run_normalize_unicode_filenames.cmd'
$sourcePs1 = Join-Path $scriptDir 'normalize_unicode_filenames.ps1'

$installedCmd = Join-Path $installRoot 'run_normalize_unicode_filenames.cmd'
$installedPs1 = Join-Path $installRoot 'normalize_unicode_filenames.ps1'

Copy-Item -LiteralPath $sourceCmd -Destination $installedCmd -Force
Copy-Item -LiteralPath $sourcePs1 -Destination $installedPs1 -Force

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
    $commandValue = ('cmd.exe /c ""%LOCALAPPDATA%\UnicodeFilenameTools\run_normalize_unicode_filenames.cmd" "{0}""' -f $argument)
    Set-Item -Path $commandKey -Value $commandValue
}

# Regenerate .reg file with %LOCALAPPDATA% based command (portable across users)
$regContent = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\NormalizeUnicodeFilenames]
@="Normalize filenames to NFC"
"Icon"="powershell.exe"

[HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\NormalizeUnicodeFilenames\command]
@="cmd.exe /c \"\"%LOCALAPPDATA%\\UnicodeFilenameTools\\run_normalize_unicode_filenames.cmd\" \"%V\"\""

[HKEY_CURRENT_USER\Software\Classes\Directory\shell\NormalizeUnicodeFilenames]
@="Normalize filenames to NFC"
"Icon"="powershell.exe"

[HKEY_CURRENT_USER\Software\Classes\Directory\shell\NormalizeUnicodeFilenames\command]
@="cmd.exe /c \"\"%LOCALAPPDATA%\\UnicodeFilenameTools\\run_normalize_unicode_filenames.cmd\" \"%1\"\""
"@

$regFile = Join-Path $scriptDir 'install_normalize_filename_context_menu.reg'
[System.IO.File]::WriteAllText($regFile, $regContent, [System.Text.UTF8Encoding]::new($false))

Write-Host 'Context menu installed.'
Write-Host "Installed to: $installRoot"
Write-Host "Command path: $installedCmd"
Write-Host ".reg file updated: $regFile"