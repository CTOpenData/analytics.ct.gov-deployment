# TO BE DELETE -- keeping for testing until we figure out remote execution issues

# Set up location for scheduler to correctly read from
param (
  [Parameter(Mandatory=$true)][string]$ProjectLocation,
  [Parameter(Mandatory=$true)][string]$OutputDirectory,
  [Parameter(Mandatory=$true)][string]$Frequency,
)

# Run the analytics cli
# . $PWD\env.ps1
$file = "$ProjectLocation\test_for_env"
Add-Content $file "hello world lets add more data "
# npx analytics --frequency realtime --slim --verbose --output $LOCATION\analytics\data
