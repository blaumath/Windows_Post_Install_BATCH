# Enable TLSv1.2 for compatibility with older clients
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

md -Force $env:TEMP\Post

$DownloadURL = 'https://raw.githubusercontent.com/8mpty/Windows_Post_Install_BATCH/testing_sperate_files/Install.cmd'

$DownloadActivator = 'https://raw.githubusercontent.com/8mpty/Windows_Post_Install_BATCH/testing_sperate_files/IndividualScripts/ActivateWindows.cmd'

$DownloadTweaker = 'https://raw.githubusercontent.com/8mpty/Windows_Post_Install_BATCH/testing_sperate_files/IndividualScripts/ChrisTitusTweaker.cmd'





$MainPath = "$env:TEMP\Post"

$InstallPath = "$MainPath\Post_Install.cmd"
$ActivatorFilePath = "$MainPath\Activator.cmd"
$TweakerFilePath = "$MainPath\Tweaker.cmd"


try {
    Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing -OutFile $InstallPath
    Invoke-WebRequest -Uri $DownloadActivator -UseBasicParsing -OutFile $ActivatorFilePath
    Invoke-WebRequest -Uri $DownloadTweaker -UseBasicParsing -OutFile $TweakerFilePath
} catch {
    Write-Error $_
	Return
}

if (Test-Path $MainPath){
    Start-Process $InstallPath -Wait
    rm $env:TEMP\Post -Recurse -Force
}