# Enable TLSv1.2 for compatibility with older clients
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

$MainURL = "https://raw.githubusercontent.com/8mpty/Windows_Post_Install_BATCH/main"
$MainPath = "$env:TEMP\POST_TEMP"

if(!(Test-Path $MainPath)){
    md -Force $MainPath | Out-Null
}

$InstallFileName = "Install.bat"

$scripts = @{
    "Install.bat" = $MainPath
    "ActivateWindows.bat" = "ActivateWindows.bat"
    "ChrisTitusTweaker.bat" = "ChrisTitusTweaker.bat"
    "StandaloneWinget.bat" = "StandaloneWinget.bat"
    "WindowsAutoLogin.bat" = "WindowsAutoLogin.bat"
    "ExtractDrivers.bat" = "ExtractDrivers.bat"
    "DownloadDebloaters.bat" = "DownloadDebloaters.bat"
    "RemoveOrRestoreFolders.bat" = "RemoveOrRestoreFolders.bat"
    "UAC.bat" = "UAC.bat"
    "FF_Profile.bat" = "FF_Profile.bat"
}

try {
    foreach ($script in $scripts.Keys) {
        $downloadURL = "$MainURL/IndividualScripts/$script"
        $filePath = "$MainPath\" + $scripts[$script]
        Invoke-WebRequest -Uri $downloadURL -UseBasicParsing -OutFile $filePath
    }
} catch {
    Write-Error $_
    return
}

if (Test-Path $MainPath) {
    Start-Process $InstallFileName -Wait -WorkingDirectory $MainPath
    Remove-Item $MainPath -Recurse -Force
}