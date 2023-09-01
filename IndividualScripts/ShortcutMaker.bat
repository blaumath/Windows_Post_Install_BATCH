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
echo Creating Shortcut....
ping 127.0.0.1 -n 3 -w 1000 > NUL
set "ShortcutName=PostScript"
set "ShortcutTarget=powershell.exe"
set "ShortcutArguments=-ExecutionPolicy RemoteSigned -Command ""Start-Process powershell.exe -WindowStyle Hidden -Verb RunAs -ArgumentList 'irm https://raw.githubusercontent.com/8mpty/Windows_Post_Install_BATCH/main/psfile/empty.ps1 | iex '"""
set "ShortcutLocation=%userprofile%\Desktop"

echo Set oWS = WScript.CreateObject("WScript.Shell") > %temp%\CreateShortcut.vbs
echo sLinkFile = "%ShortcutLocation%\%ShortcutName%.lnk" >> %temp%\CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %temp%\CreateShortcut.vbs
echo oLink.TargetPath = "%ShortcutTarget%" >> %temp%\CreateShortcut.vbs
echo oLink.Arguments = "%ShortcutArguments%" >> %temp%\CreateShortcut.vbs
echo oLink.IconLocation = "%SystemRoot%\System32\imageres.dll,56" >> %temp%\CreateShortcut.vbs
echo oLink.Hotkey = "SHIFT+ALT+CTRL+F1" >> %temp%\CreateShortcut.vbs
echo oLink.Save >> %temp%\CreateShortcut.vbs

cscript /nologo %temp%\CreateShortcut.vbs
del %temp%\CreateShortcut.vbs
echo Done!!
ping 127.0.0.1 -n 3 -w 1000 > NUL