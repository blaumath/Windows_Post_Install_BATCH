@echo off
rem CenterSelf
 
CLS
 ECHO.
 ECHO =============================
 ECHO Running Admin shell
 ECHO =============================

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~dpnx0"
 rem this works also from cmd shell, other than %~0
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
  ECHO.
  ECHO **************************************
  ECHO Invoking UAC for Privilege Escalation
  ECHO **************************************

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"
  
  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

 ::::::::::::::::::::::::::::
 ::START
 ::::::::::::::::::::::::::::
 REM Run shell as admin (example) - put here code as you like

:start
cls
title AFTER_WINDOWS_INSTALL
set ps=powershell.exe -NoProfile -ExecutionPolicy Unrestricted -Command "


echo "----------------------------------------------------------------"
echo "                        Choose Options                          "
echo "----------------------------------------------------------------"
echo.
echo 1. Activate Windows 10 (https://massgrave.dev/get)
echo 2. ChrisTitusTech's Programs Install Manager (https://christitus.com/win)
echo 3. Install Winget Alone
echo 4. Enable/Disable Windows AutoLogin (Not Entirely Safe but sure)
echo 0. Exit
echo.


echo Enter choice in your keyboard [1,2,3,4,0]: 
choice /C:12340 /N
set _erl=%errorlevel%


if %_erl%==0 goto end
if %_erl%==4 goto wal
if %_erl%==3 goto wg
if %_erl%==2 goto ctt
if %_erl%==1 goto mass

goto end

:mass
cls
title Activate Windows 10
%ps%irm https://massgrave.dev/get | iex"
goto start


:ctt
cls
title ChrisTitusTech Programs Installer
%ps%irm https://christitus.com/win | iex"
goto start


:wg
cls
echo PLEASE STAND BY....
%ps%Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted"
ping 127.0.0.1 -n 2 -w 1000 > NUL
echo Press Enter
cls
%ps%Install-Script -Name winget-install -Force"
%ps%winget-install.ps1"
pause
goto start


:wal
cls

echo "----------------------------------------------------------------"
echo "                        Windows AutoLogon                       "
echo "----------------------------------------------------------------"
echo.
echo 1. Enable Windows AutoLogon
echo 2. Disable Windows AutoLogon
echo 3. Go Back
echo 0. Exit

echo Enter choice in your keyboard [1,2,3,0]: 
choice /C:1230 /N
set _erl_wal=%errorlevel%

if %_erl_wal%==0 goto end
if %_erl_wal%==3 goto start
if %_erl_wal%==2 goto dis_wal
if %_erl_wal%==1 goto en_wal

goto end

:en_wal
cls
echo Enabling Windows AutoLogon
echo.
echo Please Input Parameters

set /P wal_user=Enter Windows Username:
set /P wal_pass=Enter Windows Password:

ping 127.0.0.1 -n 2 -w 1000 > NUL
cls
echo Please Wait
echo.

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d %wal_user%
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d %wal_pass%
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1

ping 127.0.0.1 -n 4 -w 1000 > NUL
echo DONE!
pause
goto start



:dis_wal
cls
echo Disabling Windows AutoLogon

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 0

ping 127.0.0.1 -n 4 -w 1000 > NUL
echo DONE!
pause
goto start
















:end
exit /b