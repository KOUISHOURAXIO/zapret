@echo off
chcp 65001 >nul
:: 65001 - UTF-8

tasklist /FI "IMAGENAME eq winws.exe" 2>NUL | find /I "winws.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    powershell -Command "Add-Type -AssemblyName 'Microsoft.VisualBasic'; [Microsoft.VisualBasic.Interaction]::MsgBox('Before starting, turn off the zapret service!', '16', 'Zapret')"
)

cd /d "%~dp0"
call update_zapret.bat soft
echo:

set BIN=%~dp0bin\

start "zapret: general (ALT 4)" /min "%~dp0bin\winws.exe" --wf-tcp=80,443,444-65535 --wf-udp=443,444-65535,50000-50100 ^
--filter-udp=444-65535 --ipset="%~dp0lists\ipset-amazon.txt" --dpi-desync-ttl=8 --dpi-desync-repeats=20 --dpi-desync-fooling=none --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp="%BIN%quic_initial_www_google_com.bin" --dpi-desync=fake --dpi-desync-cutoff=n10