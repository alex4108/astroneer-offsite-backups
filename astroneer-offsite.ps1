param($sourceDirectory, $onlineTarget, $retentionInDays, $install, $frequencyInMinutes) 

Start-Transcript -Path $PSScriptHome\astroneer-offsite.log -Append

$version = Get-Content -Path "version"
Write-Host "astroneer-offsite v$version"

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

if ($install -eq 1) { 
    if ($null -eq $frequencyInMinutes) { 
        $frequencyInMinutes = 15;
    }

    # Install scheduled task
    $ExecArgs = "-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File `"$PSScriptRoot\astroneer-offsite.ps1`" -sourceDirectory `"$sourceDirectory`" -onlineTarget `"$onlineTarget`" -retentionInDays $retentionInDays "
    $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $ExecArgs
    $trigger =  New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionDuration (([DateTime]::Now).AddYears(3) - (([DateTime]::Now))) -RepetitionInterval (New-TimeSpan -Minutes $frequencyInMinutes) 
    $registerResult = Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Astroneer Offsite Backups" -ErrorAction SilentlyContinue
    if (!$registerResult) {
        Unregister-ScheduledTask -TaskName "Astroneer Offsite Backups" -Confirm:$false
        Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Astroneer Offsite Backups" -ErrorAction SilentlyContinue
    }
        
    Write-Host "Scheduled Task Installed."
}


Write-Host "Listing remote directory before backup"
.\rclone\rclone.exe ls $onlineTarget

# Sync the backup directory with the online target
Write-Host "Starting sync"
.\rclone\rclone.exe sync $sourceDirectory $onlineTarget
Write-Host "rclone sync'ed.  Check for errors?"

Write-Host "Listing remote directory after backup"
.\rclone\rclone.exe ls $onlineTarget

Write-Host "Cleaning up old files"
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
Stop-Transcript