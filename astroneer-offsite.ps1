param($sourceDirectory, $onlineTarget, $retentionInDays, $install, $frequencyInMinutes) 
<# astroneer-offiste.ps1 #>

$version = Get-Content -Path "version"
Write-Host "astroneer-offsite v$version"

# The path where your astroneer data files live
if ($install -eq 1) { 
    if ($null -eq $frequencyInMinutes) { 
        $frequencyInMinutes = 15;
    }

    # Install scheduled task
    $ExecArgs = "-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File `"$PSScriptRoot\astroneer-offsite.ps1`""
    $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $ExecArgs
    $trigger =  New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes $frequencyInMinutes) -RepetitionDuration ([System.TimeSpan]::MaxValue)
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Astroneer Offsite Backups"
    Write-Host "Scheduled Task Installed."
}

if ($null -eq $sourceDirectory) { 
    Write-Host "Source directory not specified.  I can't backup if I don't know where the backups are..."
    Exit
}
if ($null -eq $onlineTarget) { 
    Write-Host "No rclone online target was defined.  Into the abyss the backups will go..."
    Exit
}
if ($null -eq $retentionInDays) { 
    $retentionInDays = 7
    Write-Host "Setting retention policy to 7 days"
}

# Sync the backup directory with the online target

.\rclone\rclone.exe sync $sourceDirectory $onlineTarget
Write-Host "rclone sync'ed.  Check for errors?"

$age = (Get-Date).AddDays(-$retentionInDays)

Get-ChildItem $sourceDirectory -Recurse -File | foreach{
    # if creationtime is 'le' (less or equal) than $retentionInDays
    if ($_.CreationTime -le $age){
        Write-Output "Older than $retentionInDays days - $($_.name)"
        Remove-Item $_.fullname -Force -Verbose
    }else{
        Write-Output "Less than $retentionInDays days old - $($_.name)"
    }
}
