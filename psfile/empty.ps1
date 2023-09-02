# Enable TLSv1.2 for compatibility with older clients
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

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
        Invoke-WebRequest -Uri "$MainURL/Install.bat" -UseBasicParsing -OutFile "$MainPath\Install.bat"
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
    if ($args.Count -eq 1) {
        $op = $args[0]
        Write-Host "ONLY 1 NO /S"
        Start-Sleep -Seconds 3
        Start-Process -FilePath "$MainPath\Install.bat" -ArgumentList "$op" -Wait

    }elseif ($args.Count -ge 2 -and $args[0] -ne "/s"){
        $op = $args[0]
        $op2 = $args[1..($args.Length - 1)] -join ' '
        Write-Host "MORE THAN 1 NO /S"
        Start-Sleep -Seconds 3
        Start-Process -FilePath "$MainPath\Install.bat" -ArgumentList "$op $op2" -Wait

    }elseif ($args.Count -ge 2 -and ($args[0] -eq "/s" -and $args[2] -ne $null)){
        $op = $args[1]
        $op2 = $args[2..($args.Length - 1)] -join ' '
        $op0 = "0"
        Write-Host "MORE THAN 1 WITH /S"
        Start-Sleep -Seconds 3
        Start-Process -FilePath "$MainPath\Install.bat" -ArgumentList "$op $op2 $op0" -NoNewWindow -RedirectStandardOutput "NUL" -RedirectStandardError "NUL" -UseShellExecute $false -Wait

    }elseif (($args.Count -ge 2 -and $args.Count -lt 3) -and ($args[0] -eq "/s" -and $args[1] -ne "/s")){
        $op = $args[1]
        Write-Host "MORE THAN 1 WITH /S ONLY 1 OPTION"
        Start-Sleep -Seconds 3
        Start-Process -FilePath "$MainPath\Install.bat" -ArgumentList "$op 0" -NoNewWindow -RedirectStandardOutput "NUL" -RedirectStandardError "NUL" -UseShellExecute $false -Wait

    } else {
        Write-Host "NORMAL"
        Start-Sleep -Seconds 3
        Start-Process -FilePath "$MainPath\Install.bat" -Wait
    }

    Remove-Item -Path $MainPath -Recurse -Force
}