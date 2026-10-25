@echo off
setlocal
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0scripts\start.ps1" %*
if errorlevel 1 (
  echo Could not start. Please fully extract the ZIP and try again.
  echo Diagnostics: .launcher-state
  pause
)
