@echo off
rem CenterSelf
mode 67, 30

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
title (TESTING_BRANCH) AFTER_WINDOWS_INSTALL
mode 67, 30
cd /D %temp%/POST_TEMP/
set ps=powershell.exe -NoProfile -ExecutionPolicy Unrestricted -Command "

echo ----------------------------------------------------------------
echo                         Choose Options                          
echo ----------------------------------------------------------------
echo.
echo 1. Activate Windows 10
echo 2. ChrisTitusTech's Programs Install Manager
echo 3. Standalone Winget Install
echo 4. Enable/Disable Windows AutoLogin
echo 5. Extract all Drivers
echo 6. Download Debloater Scripts/Programs
echo 0. Exit
echo.


echo Enter choice on your keyboard [1,2,3,4,5,6,0]: 
choice /C:1234560 /N
set _erl=%errorlevel%


if %_erl%==0 goto end
if %_erl%==6 goto download_debloaters
if %_erl%==5 goto ext_driver
if %_erl%==4 goto wal
if %_erl%==3 goto wg
if %_erl%==2 goto ctt
if %_erl%==1 goto mass

goto end

:mass
cls
call Activator.cmd
goto start

:ctt
cls
call Tweaker.cmd
goto start

:wg
cls
call Winget.cmd
goto start

:wal
cls
call AutoLogin.cmd
goto start


:ext_driver
call Drivers.cmd
goto start


:download_debloaters
call Debloaters.cmd
goto start





:end
exit /b