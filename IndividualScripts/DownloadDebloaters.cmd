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
echo ----------------------------------------------------------------
echo                         Download Options                          
echo ----------------------------------------------------------------
echo.
echo 1. Using CURL (default/builtin/slow sometimes)
echo 2. Using WGET (newer/takes up more space/needs to download)
echo 0. Exit
echo.


echo Enter choice on your keyboard [1,2,0]: 
choice /C:120 /N
set _erl=%errorlevel%

if %_erl%==0 goto end
if %_erl%==2 goto choco
if %_erl%==1 goto curl

goto end
:choco
cls
TITLE USING WGET
echo INSTALLING CHOCO IF NOT INSTALLED
ping 127.0.0.1 -n 1 -w 1000 > NUL
echo.

WHERE choco > nul
IF %ERRORLEVEL% NEQ 0 (
	echo Choco is NOT installed. Downloading.....
	ping 127.0.0.1 -n 2 -w 1000 > NUL
	@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command " [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

	echo DONE
	ping 127.0.0.1 -n 2 -w 1000 > NUL
	
) ELSE IF %ERRORLEVEL% NEQ 1 (
	echo Choco is installed. Skipping Downloading.....
	ping 127.0.0.1 -n 2 -w 1000 > NUL
)
goto wget



:wget
cls
WHERE wget > nul
IF %ERRORLEVEL% NEQ 0 (
	echo Wget is NOT installed. Downloading.....
	choco install wget
	ping 127.0.0.1 -n 2 -w 1000 > NUL
	
	echo DONE
	ping 127.0.0.1 -n 2 -w 1000 > NUL

) ELSE IF %ERRORLEVEL% NEQ 1 (
	echo Wget is installed. Skipping Downloading.....
	ping 127.0.0.1 -n 2 -w 1000 > NUL
)
goto wget_in

:wget_in
cls
TITLE USING WGET
echo Downloading builtbybel/bloatbox
ping 127.0.0.1 -n 2 -w 1000 > NUL
mkdir %UserProfile%\Downloads\bloatbox
wget -O %UserProfile%\Downloads\builtbybel.zip https://github.com/builtbybel/bloatbox/releases/download/0.20.0/bloatbox.zip & TITLE USING WGET

echo Downloading Sycnex/Windows10Debloater
ping 127.0.0.1 -n 3 -w 1000 > NUL
mkdir %UserProfile%\Downloads\Windows10Debloater
wget -O %UserProfile%\Downloads\Sycnex.zip https://github.com/Sycnex/Windows10Debloater/archive/refs/heads/master.zip
TITLE USING WGET

ping 127.0.0.1 -n 3 -w 1000 > NUL
goto extract_download_files

:curl_in
cls
TITLE USING CURL
echo Downloading builtbybel/bloatbox
ping 127.0.0.1 -n 3 -w 1000 > NUL
mkdir %UserProfile%\Downloads\bloatbox
curl -L -o %UserProfile%\Downloads\builtbybel.zip https://github.com/builtbybel/bloatbox/releases/download/0.20.0/bloatbox.zip

echo Downloading Sycnex/Windows10Debloater
ping 127.0.0.1 -n 3 -w 1000 > NUL
mkdir %UserProfile%\Downloads\Windows10Debloater
curl -L -o %UserProfile%\Downloads\Sycnex.zip https://github.com/Sycnex/Windows10Debloater/archive/refs/heads/master.zip

ping 127.0.0.1 -n 3 -w 1000 > NUL
goto extract_download_files

:extract_download_files
cls
echo EXTRACTING....

WHERE tar > NUL
IF %ERRORLEVEL% NEQ 0 (
	powershell -command "Expand-Archive -Force '%UserProfile%\Downloads\builtbybel.zip' '%UserProfile%\Downloads\bloatbox'
	powershell -command "Expand-Archive -Force '%UserProfile%\Downloads\Sycnex.zip' '%UserProfile%\Downloads\Windows10Debloater'
) ELSE IF %ERRORLEVEL% NEQ 1 (
	tar -xf %UserProfile%\Downloads\builtbybel.zip -C %UserProfile%\Downloads\bloatbox
	tar -xf %UserProfile%\Downloads\Sycnex.zip -C %UserProfile%\Downloads\Windows10Debloater
)

ping 127.0.0.1 -n 3 -w 1000 > NUL
del /f %UserProfile%\Downloads\builtbybel.zip
del /f %UserProfile%\Downloads\Sycnex.zip
echo.
echo Downloaded files to %UserProfile%\Downloads
echo.
echo Please run these scripts yourselves at your own risk!!
pause

:end
exit /b