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
echo 0. Exit
echo.


echo Enter choice in your keyboard [1,2,3,0]: 
choice /C:1230 /N
set _erl=%errorlevel%


if %_erl%==0 goto end
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
ping 127.0.0.1 -n 2 -w 3000 > NUL
echo Press Enter
cls
%ps%Install-Script -Name winget-install -Force"
%ps%winget-install.ps1"
pause
goto start



:end
exit /b