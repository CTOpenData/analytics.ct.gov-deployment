# Set up location for scheduler to correctly read from
param (
  [Parameter(Mandatory=$true)][string]$ProjectLocation,
  [Parameter(Mandatory=$true)][string]$OutputDirectory,
  [Parameter(Mandatory=$true)][string]$Frequency,
)

# Source the environment variables for interacting with the reporter
. $ProjectLocation\env.ps1

# Run the analytics cli
# npx analytics --frequency $Frequency --slim --verbose --output $OutputDirectory
