# Set up location for scheduler to correctly read from
param (
  [Parameter(Mandatory=$true)][string]$Location
)
# Realtime task (every minute)
& "SCHTASKS" `
/Create `
/SC MINUTE `
/MO 1 `
/TR "POWERSHELL $LOCATION\analytics\realtime.ps1" `
/TN Analytics-Realtime

# Daily tasks