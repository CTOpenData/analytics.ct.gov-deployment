# Set up location for scheduler to correctly read from
param (
  [Parameter(Mandatory=$true)][string]$ProjectLocation,
  [Parameter(Mandatory=$true)][string]$OutputDirectory,
)
# Realtime task (every minute)
& "SCHTASKS" `
/Create `
/SC MINUTE `
/MO 1 `
/TR "POWERSHELL $ProjectLocation\analytics\task.ps1 -ProjectLocation $ProjectLocation -OutputDirectory $OutputDirectory -Frequency realtime" `
/TN Analytics-Realtime

# Hourly tasks
& "SCHTASKS" `
/Create `
/SC HOURLY `
/MO 1 `
/TR "POWERSHELL $ProjectLocation\analytics\task.ps1 -ProjectLocation $ProjectLocation -OutputDirectory $OutputDirectory -Frequency hourly" `
/TN Analytics-Daily

# Daily tasks
& "SCHTASKS" `
/Create `
/SC DAILY `
/MO 1 `
/TR "POWERSHELL $ProjectLocation\analytics\task.ps1 -ProjectLocation $ProjectLocation -OutputDirectory $OutputDirectory -Frequency daily" `
/TN Analytics-Daily