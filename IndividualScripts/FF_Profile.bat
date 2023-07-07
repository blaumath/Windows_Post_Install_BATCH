@echo off
setlocal enabledelayedexpansion
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
cls

echo ----------------------------------------------------------------
echo                      Backup Firefox Settings                    
echo ---------------------------------------------------------------- 
echo.
echo 1. Backup settings from Firefox Folder
echo 0. Exit
echo.

echo Enter choice in your keyboard [1,0]: 
choice /C:10 /N
set _erl_wal=%errorlevel% 

if %_erl_wal%==0 goto end
if %_erl_wal%==1 goto backup

goto end


:backup
cls
SET FF=%USERPROFILE%\AppData\Roaming\Mozilla\Firefox\Profiles
set /a count=0
cd /D %FF%
echo ----------------------------------------------------------------
echo                     Available Firefox Folders                     
echo ---------------------------------------------------------------- 
echo.

for /d %%d in (*) do (
  set "folder=%%d"
  if "!folder:*.default=!" neq "!folder!" (
    echo Skipping "%%d" folder "Not Used"
  ) else (
    set /a count+=1
    set "folder[!count!]=%%d"
    echo [!count!] %%d
  )
)

echo.
set /p choice=Enter the Firefox folder number you want to backup from: 

if defined folder[%choice%] (
  cd "!folder[%choice%]!"
) else (
  cls
  echo Invalid choice.
  goto backup
)

cls
echo SAVING FILES...
mkdir saved_data
cls
echo SAVING FILES...
xcopy /y "%CD%\places.sqlite" "%CD%\saved_data"
xcopy /y "%CD%\favicons.sqlite" "%CD%\saved_data"
xcopy /y "%CD%\key4.db" "%CD%\saved_data"
xcopy /y "%CD%\logins.json" "%CD%\saved_data"
xcopy /y "%CD%\permissions.sqlite" "%CD%\saved_data"
xcopy /y "%CD%\search.json.mozlz4" "%CD%\saved_data"
xcopy /y "%CD%\persdict.dat" "%CD%\saved_data"
xcopy /y "%CD%\formhistory.sqlite" "%CD%\saved_data"
xcopy /y "%CD%\cookies.sqlite" "%CD%\saved_data"
xcopy /y "%CD%\cert9.db" "%CD%\saved_data"
xcopy /y "%CD%\handlers.json" "%CD%\saved_data"
xcopy /y "%CD%\user.js" "%CD%\saved_data"
ping 127.0.0.1 -n 2 -w 1000 > NUL
echo DONE!!
echo FILES SAVED TO %CD%\saved_data !!
%SystemRoot%\explorer.exe "%CD%\saved_data"
ping 127.0.0.1 -n 3 -w 1000 > NUL
goto start

:end
exit /b