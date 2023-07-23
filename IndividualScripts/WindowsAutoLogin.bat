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

:wal_start
cls

echo ----------------------------------------------------------------
echo                         Windows AutoLogon                       
echo ----------------------------------------------------------------

:: Check if windows auto login is enabled or disabled

set "RegKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
set "RegVal=AutoAdminLogon"

for /f "tokens=3" %%i in ('reg query "%RegKey%" /v "%RegVal%" 2^>nul') do (
    set "ValueData=%%i"
)

if defined ValueData (
    if "%ValueData%"=="1" (
        echo Status: Enabled
    ) else (
        echo Status: Disabled
    )
) else (
    echo Status: Disabled
)

ping 127.0.0.1 -n 2 -w 1000 > NUL
echo.
echo USING IS SCRIPT IS DANGEROUS, PLEASE USE CHRIS'S TITUS TECH OPTION INSTEAD, YOU HAVE BEEN WARNED
echo.
echo 1. Enable Windows AutoLogon
echo 2. Disable Windows AutoLogon
echo 0. Exit
echo.

echo Enter choice in your keyboard [1,2,0]: 
choice /C:120 /N
set _erl_wal=%errorlevel%

if %_erl_wal%==0 goto end
if %_erl_wal%==2 goto dis_wal
if %_erl_wal%==1 goto en_wal

goto end

:en_wal
cls
echo Enabling Windows AutoLogon
echo.
echo Please Input Parameters
echo [*LOGIN DETAILS WILL BE IN PLAIN TEXT IN THE REGISTRY*]
echo.
set /P wal_user=Enter Windows Username: 

:: Credits https://correct-log.com/en/bat_input_mask_with_powershell/
set "pscmd=powershell.exe -Command " ^
$inputPass = read-host 'Enter Windows Password' -AsSecureString ; ^
$BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($inputPass); ^
[System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""

for /f "tokens=*" %%a in ('%pscmd%') do set wal_pass=%%a

ping 127.0.0.1 -n 2 -w 1000 > NUL
cls
echo Please Wait
echo.

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d %wal_user% /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d %wal_pass% /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f

ping 127.0.0.1 -n 4 -w 1000 > NUL
echo DONE!
pause
goto wal_start



:dis_wal
cls
echo Disabling Windows AutoLogon
echo.

REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /f

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 0 /f
echo.
ping 127.0.0.1 -n 4 -w 1000 > NUL
echo DONE!
pause
goto wal_start

:end
exit /b

