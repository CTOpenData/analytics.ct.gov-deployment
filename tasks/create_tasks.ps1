# Set up location for scheduler to correctly read from
param (
  [Parameter(Mandatory=$true)][string]$ProjectLocation,
  [Parameter(Mandatory=$true)][string]$OutputDirectory
)
$CurrentLocation = Get-Location

POWERSHELL $CurrentLocation$ProjectLocation\task.ps1 -ProjectLocation $CurrentLocation$ProjectLocation -OutputDirectory $CurrentLocation$OutputDirectory -Frequency realtime

POWERSHELL "$CurrentLocation$ProjectLocation\teardown_tasks.ps1"

# Realtime task (every minute)
& "SCHTASKS" `
/Create `
/SC MINUTE `
/MO 1 `
/TR "POWERSHELL $CurrentLocation$ProjectLocation\task.ps1 -ProjectLocation $CurrentLocation$ProjectLocation -OutputDirectory $CurrentLocation$OutputDirectory -Frequency realtime" `
/TN Analytics-Realtime

# Hourly tasks
& "SCHTASKS" `
/Create `
/SC HOURLY `
/MO 1 `
/TR "POWERSHELL $CurrentLocation$ProjectLocation\task.ps1 -ProjectLocation $CurrentLocation$ProjectLocation -OutputDirectory $CurrentLocation$OutputDirectory -Frequency hourly" `
/TN Analytics-Hourly

# Daily tasks
& "SCHTASKS" `
/Create `
/SC DAILY `
/MO 1 `
/TR "POWERSHELL $CurrentLocation$ProjectLocation\task.ps1 -ProjectLocation $CurrentLocation$ProjectLocation -OutputDirectory $CurrentLocation$OutputDirectory -Frequency daily" `
/TN Analytics-Daily
