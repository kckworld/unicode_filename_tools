@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "TARGET_PATH=%~1"
if "%TARGET_PATH%"=="" set "TARGET_PATH=%CD%"

echo [Unicode Filename Normalize]
echo Target: %TARGET_PATH%
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%normalize_unicode_filenames.ps1" -Path "%TARGET_PATH%" -Recurse
echo.
pause