# Enable TLSv1.2 for compatibility with older clients
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

$MainURLBAT = "https://raw.githubusercontent.com/8mpty/Windows_Post_Install_BATCH/main/Install.bat"
$MainURL = "https://raw.githubusercontent.com/8mpty/Windows_Post_Install_BATCH/main"
$MainPath = "$env:TEMP\POST_TEMP"

if(!(Test-Path $MainPath)){
    md -Force $MainPath | Out-Null
}

$scripts = @{
    "Install.bat" = "Install.bat"
    "IndividualScripts/Post.bat" = "Post.bat"
    "IndividualScripts/ActivateWindows.bat" = "ActivateWindows.bat"
    "IndividualScripts/ChrisTitusTweaker.bat" = "ChrisTitusTweaker.bat"
    "IndividualScripts/StandaloneWinget.bat" = "StandaloneWinget.bat"
    "IndividualScripts/WindowsAutoLogin.bat" = "WindowsAutoLogin.bat"
    "IndividualScripts/ExtractDrivers.bat" = "ExtractDrivers.bat"
    "IndividualScripts/DownloadDebloaters.bat" = "DownloadDebloaters.bat"
    "IndividualScripts/RemoveOrRestoreFolders.bat" = "RemoveOrRestoreFolders.bat"
    "IndividualScripts/UAC.bat" = "UAC.bat"
    "IndividualScripts/FF_Profile.bat" = "FF_Profile.bat"
    "IndividualScripts/ShortcutMaker.bat" = "ShortcutMaker.bat"
    "IndividualScripts/DownloadScript.bat" = "DownloadScript.bat"
}

try {
    try {
        Invoke-WebRequest -Uri $MainURLBAT -UseBasicParsing -OutFile $MainPath
    } catch {
        foreach ($script in $scripts.GetEnumerator()) {
            $downloadURL = "$MainURL/$($script.Key)"
            $filePath = "$MainPath\$($script.Value)"
            Invoke-WebRequest -Uri $downloadURL -UseBasicParsing -OutFile $filePath
        }
    }
} catch {
    Write-Error $_
    return
}



if (Test-Path $MainPath) {
    if ($args.Count -ge 1) {
        $op = $args[0]
        $op2 = $args[1..($args.Length - 1)] -join ' '
        Start-Process -FilePath "$MainPath\Install.bat" -ArgumentList "$op $op2" -Wait
    } else {
        Start-Process -FilePath "$MainPath\Install.bat" -Wait    
    }
    Remove-Item -Path $MainPath -Recurse -Force
}