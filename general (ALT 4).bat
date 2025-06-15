@echo off
chcp 65001 >nul
:: 65001 - UTF-8

tasklist /FI "IMAGENAME eq winws.exe" 2>NUL | find /I "winws.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    powershell -Command "Add-Type -AssemblyName 'Microsoft.VisualBasic'; [Microsoft.VisualBasic.Interaction]::MsgBox('Before starting, turn off the zapret service!', '16', 'Zapret')"
)

cd /d "%~dp0"
call service.bat status_zapret
call service.bat check_updates
echo:

set BIN=%~dp0bin\
set FAKE=%~dp0fake\
set LIST=%~dp0lists\

start "zapret: general (ALT 4)" /min "%BIN%winws.exe" --wf-tcp=80,443,444-65535 --wf-udp=443,444-65535,50000-50100 ^
--filter-udp=444-65535 --ipset="%LIST%ipset-amazon.txt" --dpi-desync-ttl=8 --dpi-desync-repeats=20 --dpi-desync-fooling=none --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp="%FAKE%quic_initial_www_google_com.bin" --dpi-desync=fake --dpi-desync-cutoff=n10