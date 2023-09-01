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

IF NOT EXIST %temp%\POST_TEMP\ (cd /D ./IndividualScripts/) else ( cd /D %temp%/POST_TEMP/)
set ps=powershell.exe -NoProfile -ExecutionPolicy Unrestricted -Command "
title AFTER_WINDOWS_INSTALL
mode 67, 30

:start
cls

echo ----------------------------------------------------------------
echo                         Choose Options                          
echo ----------------------------------------------------------------
echo.
echo  [1]. Windows Activator
echo  [2]. ChrisTitusTech's Programs Install Manager
echo  [3]. Enable/Disable Windows AutoLogin
echo  [4]. Download Debloater Scripts/Programs
echo  [5]. Extras
echo  [0]. Exit
echo.

set op=%~1

if "%op%"=="" (
    set /P op=Enter your choice on your keyboard [1,2,3,4,5,0]: 
) else (
    shift
)


if %op%==0 goto end
if %op%==5 goto misc
if %op%==4 goto download_debloaters
if %op%==3 goto wal
if %op%==2 goto ctt
if %op%==1 goto mass

goto start

:misc
cls

cls
echo ----------------------------------------------------------------
echo                      Choose Options [Extras]                    
echo ----------------------------------------------------------------
echo.
echo  [1]. Standalone Winget Install
echo  [2]. Extract all Drivers
echo  [3]. Remove/Restore Folders from "This PC"
echo  [4]. Enable/Disable UAC Verification
echo  [5]. Backup Firefox Settings
echo  [6]. Create Shortcut for this script (Desktop)
echo  [9]. Go Back
echo  [0]. Exit
echo.

set op=%~1

if "%op%"=="" ( 
    set /P op=Enter choice on your keyboard [1,2,3,4,5,6,9,0]: 
) else (
    shift
)

if %op%==0 goto end
if %op%==9 goto start
if %op%==6 goto shortcutmaker
if %op%==5 goto ff
if %op%==4 goto uac_verification
if %op%==3 goto remove_restore_folders
if %op%==2 goto ext_driver
if %op%==1 goto wg

goto misc

:mass
cls
call ActivateWindows.bat
goto start

:ctt
cls
call ChrisTitusTweaker.bat
goto start

:wg
cls
call StandaloneWinget.bat
goto start

:wal
cls
call WindowsAutoLogin.bat
goto start


:ext_driver
cls
call ExtractDrivers.bat
goto start


:download_debloaters
cls
call DownloadDebloaters.bat
goto start


:remove_restore_folders
cls
call RemoveOrRestoreFolders.bat
goto start


:uac_verification
cls
call UAC.bat
goto start

:ff
cls
call FF_Profile.bat
goto start

:shortcutmaker
cls
call ShortcutMaker.bat
goto start


:end
exit /b