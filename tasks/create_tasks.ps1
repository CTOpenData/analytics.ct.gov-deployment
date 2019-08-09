# Set up location for scheduler to correctly read from
param (
  [Parameter(Mandatory=$true)][string]$ProjectLocation,
  [Parameter(Mandatory=$true)][string]$OutputDirectory,
  [Parameter(Mandatory=$true)][string]$Username,
  [Parameter(Mandatory=$true)][string]$Password
)
$CurrentLocation = Get-Location

POWERSHELL $CurrentLocation$ProjectLocation\task.ps1 -ProjectLocation $CurrentLocation$ProjectLocation -OutputDirectory $CurrentLocation$OutputDirectory -Frequency realtime

POWERSHELL "$CurrentLocation$ProjectLocation\teardown_tasks.ps1"

$Principal = New-ScheduledTaskPrincipal -UserId $Username -LogonType Password

# Realtime task (every minute)
$RealtimeTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-Timespan -Minutes 1)
$RealtimeAction = New-ScheduledTaskAction -Execute "POWERSHELL $CurrentLocation$ProjectLocation\task.ps1 -ProjectLocation $CurrentLocation$ProjectLocation -OutputDirectory $CurrentLocation$OutputDirectory -Frequency realtime" `
Register-ScheduledTask -TaskName "Analytics-Realtime" -Trigger $RealtimeTrigger -Action $RealtimeAction -Principal $Principal -Password $Password

# Daily tasks
$HourlyTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-Timespan -Hours 1)
$HourlyAction = New-ScheduledTaskAction -Execute "POWERSHELL $CurrentLocation$ProjectLocation\task.ps1 -ProjectLocation $CurrentLocation$ProjectLocation -OutputDirectory $CurrentLocation$OutputDirectory -Frequency hourly" `
Register-ScheduledTask -TaskName "Analytics-Hourly" -Trigger $HourlyTrigger -Action $HourlyAction -Principal $Principal -Password $Password

# Daily tasks
$DailyTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-Timespan -Hours 1)
$DailyAction = New-ScheduledTaskAction -Execute "POWERSHELL $CurrentLocation$ProjectLocation\task.ps1 -ProjectLocation $CurrentLocation$ProjectLocation -OutputDirectory $CurrentLocation$OutputDirectory -Frequency daily" `
Register-ScheduledTask -TaskName "Analytics-Daily" -Trigger $DailyTrigger -Action $DailyAction -Principal $Principal -Password $Password
