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
title Remove or Restore Folders
mode 67, 30
cls
echo ----------------------------------------------------------------
echo                          Choose Options                          
echo ----------------------------------------------------------------
echo.
echo 1. Remove Folders
echo 2. Restore Folders
echo 0. Exit
echo.

echo Enter choice on your keyboard [1,2,0]: 
choice /C:120 /N
set _erl=%errorlevel%
if %_erl%==0 goto end
if %_erl%==2 goto RESTORE_FOLDERS
if %_erl%==1 goto Architecture
goto end


:Architecture
cls
echo ----------------------------------------------------------------
echo                          Choose Type                          
echo ----------------------------------------------------------------
echo.

if exist "%SYSTEMDRIVE%\Program Files (x86)\" (
   echo Your Type is 64-Bit
) else (
   echo Your Type is 32-Bit/x86
)

echo.
echo 1. 64-bit Architecture
echo 2. 32-bit/x86 Architecture
echo 0. Go Back
echo.

echo Enter choice on your keyboard [1,2,0]: 
choice /C:120 /N
set _erl=%errorlevel%
if %_erl%==0 goto start
if %_erl%==2 goto 32bit
if %_erl%==1 goto 64bit
goto start




















:32bit
title 32-Bit
cls
echo ----------------------------------------------------------------
echo                          Choose Options                          
echo ----------------------------------------------------------------
echo.
echo 1. Remove All Folders
echo 2. Restore Individual Folders
echo 0. Go Back
echo.

echo Enter choice on your keyboard [1,2,0]: 
choice /C:120 /N
set _erl=%errorlevel%
if %_erl%==0 goto start
if %_erl%==2 goto 32_INDI
if %_erl%==1 goto 32_ALL
goto start





:32_ALL
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
cls
ping 127.0.0.1 -n 2 -w 1000 > NUL
echo Removing All Folders
echo Please Wait....
ping 127.0.0.1 -n 2 -w 1000 > NUL
echo.

echo Removing Desktop Folder
REG DELETE "%def%" /v "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"
ping 127.0.0.1 -n 4 -w 1000 > NUL
echo Removing Documents Folder
REG DELETE "%def%" /v "{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}"
REG DELETE "%def%" /v "{d3162b92-9365-467a-956b-92703aca08af}"
ping 127.0.0.1 -n 4 -w 1000 > NUL
echo Removing Downloads Folder
REG DELETE "%def%" /v "{374DE290-123F-4565-9164-39C4925E467B}"
REG DELETE "%def%" /v "{088e3905-0323-4b02-9826-5d99428e115f}"
ping 127.0.0.1 -n 4 -w 1000 > NUL
echo Removing Music Folder
REG DELETE "%def%" /v "{1CF1260C-4DD0-4ebb-811F-33C572699FDE}"
REG DELETE "%def%" /v "{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}"
ping 127.0.0.1 -n 4 -w 1000 > NUL
echo Removing Pictures Folder
REG DELETE "%def%" /v "{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}"
REG DELETE "%def%" /v "{24ad3ad4-a569-4530-98e1-ab02f9417aa8}"
ping 127.0.0.1 -n 4 -w 1000 > NUL
echo Removing Videos Folder
REG DELETE "%def%" /v "{A0953C92-50DC-43bf-BE83-3742FED03C9C}"
REG DELETE "%def%" /v "{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"
ping 127.0.0.1 -n 4 -w 1000 > NUL
echo.
echo Remove Successfull!
ping 127.0.0.1 -n 4 -w 1000 > NUL
goto start







:32_Desktop
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Removing Desktop Folder
REG DELETE "%def%" /v "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"
echo Remove Successfull!
ping 127.0.0.1 -n 4 -w 1000 > NUL
goto start

:32_Documents
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Removing Documents Folder
REG DELETE "%def%" /v "{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}"
REG DELETE "%def%" /v "{d3162b92-9365-467a-956b-92703aca08af}"
echo Remove Successfull!
ping 127.0.0.1 -n 4 -w 1000 > NUL
goto start

:32_Downloads
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Removing Downloads Folder
REG DELETE "%def%" /v "{374DE290-123F-4565-9164-39C4925E467B}"
REG DELETE "%def%" /v "{088e3905-0323-4b02-9826-5d99428e115f}"
echo Remove Successfull!
ping 127.0.0.1 -n 4 -w 1000 > NUL
goto start

:32_Music
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Removing Music Folder
REG DELETE "%def%" /v "{1CF1260C-4DD0-4ebb-811F-33C572699FDE}"
REG DELETE "%def%" /v "{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}"
echo Remove Successfull!
ping 127.0.0.1 -n 4 -w 1000 > NUL
goto start

:32_Pictures
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Removing Pictures Folder
REG DELETE "%def%" /v "{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}"
REG DELETE "%def%" /v "{24ad3ad4-a569-4530-98e1-ab02f9417aa8}"
echo Remove Successfull!
ping 127.0.0.1 -n 4 -w 1000 > NUL
goto start

:32_Videos
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Removing Videos Folder
REG DELETE "%def%" /v "{A0953C92-50DC-43bf-BE83-3742FED03C9C}"
REG DELETE "%def%" /v "{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"
echo Remove Successfull!
ping 127.0.0.1 -n 4 -w 1000 > NUL
goto start





:RESTORE_FOLDERS
cls
goto start

:end
exit /b