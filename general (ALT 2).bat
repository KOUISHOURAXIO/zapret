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

start "zapret: general (ALT 2)" /min "%BIN%winws.exe" --wf-tcp=80,443 --wf-udp=443,50000-50100 ^
--filter-udp=443 --hostlist-exclude="%LIST%list-exclude.txt" --ipset="%LIST%list-ipset.txt" --hostlist="%LIST%list.txt" --hostlist="%LIST%list-additional.txt" --hostlist-auto-fail-time=3 --hostlist-auto-fail-threshold=1 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%FAKE%quic_google.bin" --new ^
--filter-udp=50000-50100 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
--filter-tcp=80 --hostlist-exclude="%LIST%list-exclude.txt" --ipset="%LIST%list-ipset.txt" --hostlist="%LIST%list.txt" --hostlist="%LIST%list-additional.txt" --hostlist-auto-fail-time=3 --hostlist-auto-fail-threshold=1 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist-exclude="%LIST%list-exclude.txt" --ipset="%LIST%list-ipset.txt" --hostlist="%LIST%list.txt" --hostlist="%LIST%list-additional.txt" --hostlist-auto-fail-time=3 --hostlist-auto-fail-threshold=1 --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%FAKE%tls_google.bin" --new ^
--filter-udp=443 --ipset="%LIST%list-cloudflare&amazon.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%FAKE%quic_google.bin" --new ^
--filter-udp=50000-50100 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
--filter-tcp=80 --ipset="%LIST%list-cloudflare&amazon.txt" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --ipset="%LIST%list-cloudflare&amazon.txt" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%FAKE%tls_google.bin"
