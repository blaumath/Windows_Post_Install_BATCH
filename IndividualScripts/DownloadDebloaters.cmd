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
cls
echo INSTALLING CHOCO IF NOT INSTALLED
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command " [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

echo PLEASE WAIT
ping 127.0.0.1 -n 5 -w 1000 > NUL
echo.

echo INSTALLING WGET
choco install wget
ping 127.0.0.1 -n 3 -w 1000 > NUL

cls
echo Downloading builtbybel/bloatbox
ping 127.0.0.1 -n 3 -w 1000 > NUL
mkdir %UserProfile%\Downloads\bloatbox
wget -O %UserProfile%\Downloads\builtbybel.zip https://github.com/builtbybel/bloatbox/releases/download/0.20.0/bloatbox.zip

echo Downloading Sycnex/Windows10Debloater
ping 127.0.0.1 -n 3 -w 1000 > NUL
mkdir %UserProfile%\Downloads\Windows10Debloater
wget -O %UserProfile%\Downloads\Sycnex.zip https://github.com/Sycnex/Windows10Debloater/archive/refs/heads/master.zip

ping 127.0.0.1 -n 3 -w 1000 > NUL
goto extract_download_files


:extract_download_files
cls
echo EXTRACTING....
tar -xf %UserProfile%\Downloads\builtbybel.zip -C %UserProfile%\Downloads\bloatbox
tar -xf %UserProfile%\Downloads\Sycnex.zip -C %UserProfile%\Downloads\Windows10Debloater
ping 127.0.0.1 -n 3 -w 1000 > NUL
del /f %UserProfile%\Downloads\builtbybel.zip
del /f %UserProfile%\Downloads\Sycnex.zip
echo.
echo Downloaded files to %UserProfile%\Downloads
echo.
echo Please run these scripts yourselves at your own risk!!
pause