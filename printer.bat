@echo OFF

set INF_10_64=C:\printer\download\driver\UFRII_Driver_Win10_V3015_W64_ukEN_01\Driver\CNLB0KA64.inf
set INF_7_64=C:\printer\download\driver\UFRII_Driver_Win10_V3015_W64_ukEN_01\Driver\CNLB0KA64.inf
set MODEL=Canon iR-ADV C3320 UFR II
set NAME=Canon iR-ADV C3320 UFR II-test
set DOWNLOAD=UFRII_Driver_Win10_V3015_W64_ukEN_01
set IP=192.168.168.23

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

cscript C:\Windows\System32\Printing_Admin_Scripts\en-US\PRNMNGR.vbs -d -p "%NAME%

IF EXIST C:\printer\wget.exe GOTO SKIPWGET
echo get wget
mkdir c:\printer
powershell.exe  -command "Invoke-WebRequest -Uri http://mis/download/utility/wget.exe  -OutFile c:\printer\wget.exe" 
:SKIPWGET

IF EXIST C:\printer\download\driver\%DOWNLOAD% GOTO SKIPDRIVER
echo get driver
c:\printer\wget.exe --recursive --no-host-directories --no-parent --include "download/driver/%DOWNLOAD%" "http://mis/download/driver/%DOWNLOAD%" --directory c:\printer
:SKIPDRIVER

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

cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prnport.vbs -a -r IP_%IP% -h %IP%
printui.exe /if /b "%NAME%"  /u /r IP_%IP% /m "%MODEL%"
pause
