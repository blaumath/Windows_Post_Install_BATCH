# Enable TLSv1.2 for compatibility with older clients
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

$MainURL = "https://raw.githubusercontent.com/8mpty/Windows_Post_Install_BATCH/main"
$MainPath = "$env:TEMP\POST_TEMP"

if(!(Test-Path $MainPath)){
    md -Force $MainPath | Out-Null
}

$DownloadURL = "$MainURL/Install.bat"

# Download Individual Scripts
$DownloadActivator = "$MainURL/IndividualScripts/ActivateWindows.bat"
$DownloadTweaker = "$MainURL/IndividualScripts/ChrisTitusTweaker.bat"
$DownloadWinget = "$MainURL/IndividualScripts/StandaloneWinget.bat"
$DownloadAutoLogin = "$MainURL/IndividualScripts/WindowsAutoLogin.bat"
$DownloadDrivers = "$MainURL/IndividualScripts/ExtractDrivers.bat"
$DownloadDebloaters = "$MainURL/IndividualScripts/DownloadDebloaters.bat"
$DownloadFolderStuff = "$MainURL/IndividualScripts/RemoveOrRestoreFolders.bat"
$DownloadUAC = "$MainURL/IndividualScripts/UAC.bat"

# Set PATHS
$InstallPath = "$MainPath\Post_Install.bat"
$ActivatorFilePath = "$MainPath\ActivateWindows.bat"
$TweakerFilePath = "$MainPath\ChrisTitusTweaker.bat"
$WingetFilePath = "$MainPath\StandaloneWinget.bat"
$AutoLoginFilePath = "$MainPath\WindowsAutoLogin.bat"
$DriversFilePath = "$MainPath\ExtractDrivers.bat"
$DebloaterFilePath = "$MainPath\DownloadDebloaters.bat"
$FolderStufFilePath = "$MainPath\RemoveOrRestoreFolders.bat"
$UACFilePath = "$MainPath\UAC.bat"

try {
    Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing -OutFile $InstallPath
    Invoke-WebRequest -Uri $DownloadActivator -UseBasicParsing -OutFile $ActivatorFilePath
    Invoke-WebRequest -Uri $DownloadTweaker -UseBasicParsing -OutFile $TweakerFilePath
    Invoke-WebRequest -Uri $DownloadWinget -UseBasicParsing -OutFile $WingetFilePath
    Invoke-WebRequest -Uri $DownloadAutoLogin -UseBasicParsing -OutFile $AutoLoginFilePath
    Invoke-WebRequest -Uri $DownloadDrivers -UseBasicParsing -OutFile $DriversFilePath
    Invoke-WebRequest -Uri $DownloadDebloaters -UseBasicParsing -OutFile $DebloaterFilePath
    Invoke-WebRequest -Uri $DownloadFolderStuff -UseBasicParsing -OutFile $FolderStufFilePath
    Invoke-WebRequest -Uri $DownloadUAC -UseBasicParsing -OutFile $UACFilePath
} catch {
    Write-Error $_
	Return
}

if (Test-Path $MainPath){
    Start-Process $InstallPath -Wait
    rm $MainPath -Recurse -Force
}