# Setup env variables
param (
  [Parameter(Mandatory=$true)][string]$UserName,
  [Parameter(Mandatory=$true)][string]$Password,
  [Parameter(Mandatory=$true)][string]$HostIP,
  [Parameter(Mandatory=$true)][string]$HostKey
  )
$CurrentDirectory = Get-Location

# Download and build site
git clone -b master --single-branch https://github.com/CTOpenData/analytics.ct.gov.git analytics-site
Push-Location .\analytics-site
bundle exec jekyll build
Remove-Item .\_site\fake-data\ -recurse
Remove-Item .\_site\docker-compose.yml
Remove-Item .\_site\Dockerfile
Remove-Item .\_site\Dockerfile.production 
Remove-Item .\_site\nginx.conf 
Remove-Item .\_site\package-lock.json
Remove-Item .\_site\package.json
Remove-Item .\_site\webpack.config.js
Pop-Location

# Upload files
& "winscp" `
  /log="${CurrentDirectory}\log\WinSCP.log" /ini=nul `
  /command `
    "open sftp://${UserName}:${Password}@${HostIP}/ -hostkey=`"`"$HostKey`"`"" `
    "cd analytics" `
    "synchronize remote -delete .\analytics-site\_site\" `
    "exit"

$winscpResult = $LastExitCode
if ($winscpResult -eq 0)
{
  Write-Host "Success"
}
else
{
  Write-Host "Error"
}

Pop-Location
exit $winscpResult
