@echo off
setlocal
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0scripts\gui.ps1" %*
if errorlevel 1 pause
