@echo OFF
REM set variable
set INF_10_64=C:\printer\download\driver\UFRII_Driver_Win10_V3015_W64_ukEN_01\Driver\CNLB0KA64.inf
set INF_7_64=C:\printer\download\driver\UFRII_Driver_Win10_V3015_W64_ukEN_01\Driver\CNLB0KA64.inf
set MODEL=Canon iR-ADV C5045/5051 UFR II
set NAME=Canon iR-ADV C5051 UFR II-Level 1
set DOWNLOAD=UFRII_Driver_Win10_V3015_W64_ukEN_01

set IP=192.168.168.22

REM check cpu type
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

REM delete existing printer if found
cscript C:\Windows\System32\Printing_Admin_Scripts\en-US\PRNMNGR.vbs -d -p "%NAME%

REM download wget
IF EXIST C:\printer\wget.exe GOTO SKIPWGET
echo get wget
mkdir c:\printer
powershell.exe  -command "(New-Object system.Net.WebClient).DownloadFile('http://test/utility/wget.exe','c:\printer\wget.exe')" 
:SKIPWGET

REM download printer driver
IF EXIST C:\printer\download\driver\%DOWNLOAD% GOTO SKIPDRIVER
echo get driver
c:\printer\wget.exe --recursive --no-host-directories -R "index.html*" --no-parent --include "download/driver/%DOWNLOAD%" "http://mis.samwoh.com.sg/download/driver/%DOWNLOAD%" --directory c:\printer
:SKIPDRIVER

REM update driver store
ver | findstr /i "6\.1\." > nul
if %ERRORLEVEL% EQU 0 (
echo OS = Windows 7 / Server 2008R2
if %OS%==32BIT echo This is a 32bit operating system
if %OS%==64BIT pnputil -a "%INF_7_64%"
)
ver | findstr /i "10\.0\." > nul
if %ERRORLEVEL% EQU 0 (
echo OS = Windows 10
if %OS%==32BIT echo This is a 32bit operating system
if %OS%==64BIT pnputil -a "%INF_10_64%"
)

REM install printer
cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prnport.vbs -a -r IP_%IP% -h %IP%
printui.exe /if /b "%NAME%"  /u /r IP_%IP% /m "%MODEL%"
rundll32 printui.dll,PrintUIEntry /p /n "%NAME%"
pause

