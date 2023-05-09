# Enable TLSv1.2 for compatibility with older clients
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

md -Force $env:TEMP\POST_TEMP

$MainURL = "https://raw.githubusercontent.com/8mpty/Windows_Post_Install_BATCH/testing_sperate_files"

$DownloadURL = "$MainURL/Install.cmd"

# Download Individual Scripts
$DownloadActivator = "$MainURL/IndividualScripts/ActivateWindows.cmd"
$DownloadTweaker = "$MainURL/IndividualScripts/ChrisTitusTweaker.cmd"
$DownloadWinget = "$MainURL/IndividualScripts/StandaloneWinget.cmd"
$DownloadAutoLogin = "$MainURL/IndividualScripts/WindowsAutoLogin.cmd"
$DownloadDrivers = "$MainURL/IndividualScripts/ExtractDrivers.cmd"
$DownloadDebloaters = "$MainURL/IndividualScripts/DownloadDebloaters.cmd"


$MainPath = "$env:TEMP\POST_TEMP"

# Set PATHS
$InstallPath = "$MainPath\Post_Install.cmd"
$ActivatorFilePath = "$MainPath\ActivateWindows.cmd"
$TweakerFilePath = "$MainPath\ChrisTitusTweaker.cmd"
$WingetFilePath = "$MainPath\StandaloneWinget.cmd"
$AutoLoginFilePath = "$MainPath\WindowsAutoLogin.cmd"
$DriversFilePath = "$MainPath\ExtractDrivers.cmd"
$DebloaterFilePath = "$MainPath\DownloadDebloaters.cmd"


try {
    Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing -OutFile $InstallPath
    Invoke-WebRequest -Uri $DownloadActivator -UseBasicParsing -OutFile $ActivatorFilePath
    Invoke-WebRequest -Uri $DownloadTweaker -UseBasicParsing -OutFile $TweakerFilePath
    Invoke-WebRequest -Uri $DownloadWinget -UseBasicParsing -OutFile $WingetFilePath
    Invoke-WebRequest -Uri $DownloadAutoLogin -UseBasicParsing -OutFile $AutoLoginFilePath
    Invoke-WebRequest -Uri $DownloadDrivers -UseBasicParsing -OutFile $DriversFilePath
    Invoke-WebRequest -Uri $DownloadDebloaters -UseBasicParsing -OutFile $DebloaterFilePath
} catch {
    Write-Error $_
	Return
}

if (Test-Path $MainPath){
    Start-Process $InstallPath -Wait
    rm $MainPath -Recurse -Force
}