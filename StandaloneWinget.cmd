@echo off


cls
echo PLEASE STAND BY....

%ps%Set-ExecutionPolicy Unrestricted -Scope CurrentUser"
ping 127.0.0.1 -n 2 -w 1000 > NUL

%ps%Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted"
ping 127.0.0.1 -n 2 -w 1000 > NUL

::echo Press Enter

%ps%Install-Script -Name winget-install -Force"
ping 127.0.0.1 -n 2 -w 1000 > NUL

%ps%winget-install.ps1"
ping 127.0.0.1 -n 2 -w 1000 > NUL