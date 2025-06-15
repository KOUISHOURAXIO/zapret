@echo off
chcp 65001 >nul
:: 65001 - UTF-8

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"
set LIST=%~dp0lists\

:: The need to update is checked once every half an hour, but they are updated only when the changes appear that must be reflected in them. on domains.lst
curl -o "%lists\%list.txt" https://antifilter.download/list/domains.lst
sc query zapret | findstr "RUNNING PENDING" >nul && sc stop zapret >nul & timeout /t 2 & sc start zapret >nul
exit