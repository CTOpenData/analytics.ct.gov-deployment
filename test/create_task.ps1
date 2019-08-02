param (
  [Parameter(Mandatory=$true)][string]$ProjectLocation,
  [Parameter(Mandatory=$true)][string]$OutputDirectory
)
$CurrentLocation = Get-Location

Write-Host "$CurrentLocation$ProjectLocation\task.ps1"

POWERSHELL $CurrentLocation$ProjectLocation\task.ps1 -ProjectLocation $CurrentLocation$ProjectLocation

& "SCHTASKS" `
/Create `
/SC MINUTE `
/MO 1 `
/TR "powershell -File $CurrentLocation$ProjectLocation\parent.ps1" `
/TN Test