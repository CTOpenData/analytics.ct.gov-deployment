# Set up location for scheduler to correctly read from
param (
  [Parameter(Mandatory=$true)][string]$ProjectLocation,
  [Parameter(Mandatory=$true)][string]$OutputDirectory,
  [Parameter(Mandatory=$true)][string]$Frequency
)

Push-Location "$ProjectLocation\analytics-reporter"
npm i

# Source the environment variables for interacting with the reporter
. $ProjectLocation\env.ps1

# Run the analytics cli
Write-Host "running $Frequency"

mkdir -Force $OutputDirectory

npx analytics --frequency $Frequency --verbose --output $OutputDirectory

Pop-Location
