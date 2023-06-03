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
title Architecture Type
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
echo 1. Remove Desktop Folder
echo 2. Remove Documents Folder
echo 3. Remove Downloads Folder
echo 4. Remove Music Folder
echo 5. Remove Pictures Folder
echo 6. Remove Videos Folder
echo 7. Remove ALL Folders
echo 0. Go Back
echo.

echo Enter choice on your keyboard [1,2,3,4,5,6,7,0]: 
choice /C:12345670 /N
set _erl=%errorlevel%
if %_erl%==0 goto Architecture
if %_erl%==7 goto 32_ALL
if %_erl%==6 goto 32_Videos
if %_erl%==5 goto 32_Pictures
if %_erl%==4 goto 32_Music
if %_erl%==3 goto 32_Downloads
if %_erl%==2 goto 32_Documents
if %_erl%==1 goto 32_Desktop
goto Architecture


:32_ALL
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
set delay=2
cls
ping 127.0.0.1 -n 2 -w 1000 > NUL
echo Removing All Folders
echo Please Wait....
ping 127.0.0.1 -n 2 -w 1000 > NUL
echo.

echo Removing Desktop Folder
REG DELETE "%def%\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo Removing Documents Folder
REG DELETE "%def%\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
REG DELETE "%def%\{d3162b92-9365-467a-956b-92703aca08af}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo Removing Downloads Folder
REG DELETE "%def%\{374DE290-123F-4565-9164-39C4925E467B}" /f
REG DELETE "%def%\{088e3905-0323-4b02-9826-5d99428e115f}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo Removing Music Folder
REG DELETE "%def%\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
REG DELETE "%def%\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo Removing Pictures Folder
REG DELETE "%def%\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
REG DELETE "%def%\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo Removing Videos Folder
REG DELETE "%def%\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
REG DELETE "%def%\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo.
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start




:32_Desktop
set delay=2
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Removing Desktop Folder
REG DELETE "%def%\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:32_Documents
set delay=2
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Removing Documents Folder
REG DELETE "%def%\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
REG DELETE "%def%\{d3162b92-9365-467a-956b-92703aca08af}" /f
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:32_Downloads
set delay=2
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Removing Downloads Folder
REG DELETE "%def%\{374DE290-123F-4565-9164-39C4925E467B}" /f
REG DELETE "%def%\{088e3905-0323-4b02-9826-5d99428e115f}" /f
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:32_Music
set delay=2
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Removing Music Folder
REG DELETE "%def%\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
REG DELETE "%def%\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:32_Pictures
set delay=2
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Removing Pictures Folder
REG DELETE "%def%\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
REG DELETE "%def%"\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:32_Videos
set delay=2
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Removing Videos Folder
REG DELETE "%def%\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
REG DELETE "%def%\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start




































:64bit
title 64-Bit
cls
echo ----------------------------------------------------------------
echo                          Choose Options                          
echo ----------------------------------------------------------------
echo.
echo 1. Remove Desktop Folder
echo 2. Remove Documents Folder
echo 3. Remove Downloads Folder
echo 4. Remove Music Folder
echo 5. Remove Pictures Folder
echo 6. Remove Videos Folder
echo 7. Remove ALL Folders
echo 0. Go Back
echo.

echo Enter choice on your keyboard [1,2,3,4,5,6,7,0]: 
choice /C:12345670 /N
set _erl=%errorlevel%
if %_erl%==0 goto Architecture
if %_erl%==7 goto 64_ALL
if %_erl%==6 goto 64_Videos
if %_erl%==5 goto 64_Pictures
if %_erl%==4 goto 64_Music
if %_erl%==3 goto 64_Downloads
if %_erl%==2 goto 64_Documents
if %_erl%==1 goto 64_Desktop
goto Architecture


:64_ALL
cls
set delay=2
ping 127.0.0.1 -n 2 -w 1000 > NUL
echo Removing All Folders
echo Please Wait....
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo.

echo Removing Desktop Folder
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL

echo Removing Documents Folder
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL

echo Removing Downloads Folder
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL

echo Removing Music Folder
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL

echo Removing Pictures Folder
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL

echo Removing Videos Folder
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo.
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start




:64_Desktop
set delay=2
cls
echo Removing Desktop Folder
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:64_Documents
set delay=2
cls
echo Removing Documents Folder
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:64_Downloads
set delay=2
cls
echo Removing Downloads Folder
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:64_Music
set delay=2
cls
echo Removing Music Folder
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:64_Pictures
set delay=2
cls
echo Removing Pictures Folder
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:64_Videos
set delay=2
cls
echo Removing Videos Folder
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start






















:RESTORE_FOLDERS
title Architecture Type
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
if %_erl%==2 goto 32bit_RES
if %_erl%==1 goto 64bit_RES
goto start


:32bit_RES
title 32-Bit
cls
echo ----------------------------------------------------------------
echo                          Choose Options                          
echo ----------------------------------------------------------------
echo.
echo 1. Restore Desktop Folder
echo 2. Restore Documents Folder
echo 3. Restore Downloads Folder
echo 4. Restore Music Folder
echo 5. Restore Pictures Folder
echo 6. Restore Videos Folder
echo 7. Restore ALL Folders
echo 0. Go Back
echo.

echo Enter choice on your keyboard [1,2,3,4,5,6,7,0]: 
choice /C:12345670 /N
set _erl=%errorlevel%
if %_erl%==0 goto RESTORE_FOLDERS
if %_erl%==7 goto 32_ALL_RES
if %_erl%==6 goto 32_Videos_RES
if %_erl%==5 goto 32_Pictures_RES
if %_erl%==4 goto 32_Music_RES
if %_erl%==3 goto 32_Downloads_RES
if %_erl%==2 goto 32_Documents_RES
if %_erl%==1 goto 32_Desktop_RES
goto RESTORE_FOLDERS


:32_ALL_RES
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
set delay=2
cls
ping 127.0.0.1 -n 2 -w 1000 > NUL
echo Restoring All Folders
echo Please Wait....
ping 127.0.0.1 -n 2 -w 1000 > NUL
echo.

echo Restoring Desktop Folder
REG ADD "%def%\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo Restoring Documents Folder
REG ADD "%def%\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
REG ADD "%def%\{d3162b92-9365-467a-956b-92703aca08af}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo Restoring Downloads Folder
REG ADD "%def%\{374DE290-123F-4565-9164-39C4925E467B}" /f
REG ADD "%def%\{088e3905-0323-4b02-9826-5d99428e115f}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo Restoring Music Folder
REG ADD "%def%\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
REG ADD "%def%\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo Restoring Pictures Folder
REG ADD "%def%\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
REG ADD "%def%\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo Restoring Videos Folder
REG ADD "%def%\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
REG ADD "%def%\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo.
echo Restoring Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start




:32_Desktop_RES
set delay=2
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Restoring Desktop Folder
REG ADD "%def%\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
echo Restoring Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:32_Documents_RES
set delay=2
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Restoring Documents Folder
REG ADD "%def%\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
REG ADD "%def%\{d3162b92-9365-467a-956b-92703aca08af}" /f
echo Restoring Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:32_Downloads_RES
set delay=2
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Restoring Downloads Folder
REG ADD "%def%\{374DE290-123F-4565-9164-39C4925E467B}" /f
REG ADD "%def%\{088e3905-0323-4b02-9826-5d99428e115f}" /f
echo Restoring Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:32_Music_RES
set delay=2
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Restoring Music Folder
REG ADD "%def%\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
REG ADD "%def%\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
echo Restoring Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:32_Pictures_RES
set delay=2
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Restoring Pictures Folder
REG ADD "%def%\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
REG ADD "%def%\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
echo Restoring Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:32_Videos_RES
set delay=2
set def=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
echo Restoring Videos Folder
REG ADD "%def%\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
REG ADD "%def%\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
echo Restoring Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start




































:64bit_RES
title 64-Bit
cls
echo ----------------------------------------------------------------
echo                          Choose Options                          
echo ----------------------------------------------------------------
echo.
echo 1. Restore Desktop Folder
echo 2. Restore Documents Folder
echo 3. Restore Downloads Folder
echo 4. Restore Music Folder
echo 5. Restore Pictures Folder
echo 6. Restore Videos Folder
echo 7. Restore ALL Folders
echo 0. Go Back
echo.

echo Enter choice on your keyboard [1,2,3,4,5,6,7,0]: 
choice /C:12345670 /N
set _erl=%errorlevel%
if %_erl%==0 goto RESTORE_FOLDERS
if %_erl%==7 goto 64_ALL_RES
if %_erl%==6 goto 64_Videos_RES
if %_erl%==5 goto 64_Pictures_RES
if %_erl%==4 goto 64_Music_RES
if %_erl%==3 goto 64_Downloads_RES
if %_erl%==2 goto 64_Documents_RES
if %_erl%==1 goto 64_Desktop_RES
goto RESTORE_FOLDERS


:64_ALL_RES
cls
set delay=2
ping 127.0.0.1 -n 2 -w 1000 > NUL
echo Restoring All Folders
echo Please Wait....
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo.

echo Restoring Desktop Folder
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL

echo Restoring Documents Folder
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL

echo Restoring Downloads Folder
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL

echo Restoring Music Folder
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL

echo Restoring Pictures Folder
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL

echo Restoring Videos Folder
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
ping 127.0.0.1 -n %delay% -w 1000 > NUL
echo.
echo Restoring Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start




:64_Desktop_RES
set delay=2
cls
echo Restoring Desktop Folder
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
echo Remove Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:64_Documents_RES
set delay=2
cls
echo Restoring Documents Folder
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
echo Restoring Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:64_Downloads_RES
set delay=2
cls
echo Restoring Downloads Folder
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
echo Restoring Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:64_Music_RES
set delay=2
cls
echo Restoring Music Folder
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
echo Restoring Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:64_Pictures_RES
set delay=2
cls
echo Restoring Pictures Folder
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
echo Restoring Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start

:64_Videos_RES
set delay=2
cls
echo Restoring Videos Folder
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
echo Restoring Successfull!
ping 127.0.0.1 -n %delay% -w 1000 > NUL
goto start






:end
exit /b