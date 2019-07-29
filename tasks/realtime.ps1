# Set up location for scheduler to correctly read from
param (
  [Parameter(Mandatory=$true)][string]$Location
)
# Run the analytics cli
# . $PWD\env.ps1
$file = "$LOCATION\analytics\test_for_env"
Add-Content $file "hello world lets add more data "
# npx analytics --frequency realtime --slim --verbose --output $LOCATION\analytics\data
