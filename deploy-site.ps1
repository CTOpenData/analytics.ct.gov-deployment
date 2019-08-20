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
bundle
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

Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"

# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = $HostIP
    UserName = $UserName
    Password = $Password
    SshHostKeyFingerprint = $HostKey
}

$session = New-Object WinSCP.Session
try
{
    # Connect
    $session.Open($sessionOptions)
    Write-Host "Uploading files"
    $synchronizationResult = $session.SynchronizeDirectories(
      [WinSCP.SynchronizationMode]::Remote, "$CurrentDirectory\analytics-site\_site\", "analytics", $true)
    $synchronizationResult.Check()
    Write-Host $synchronizationResult.Uploads
    foreach ($uploadedFile in $synchronizationResult.Uploads)
        {
            if ($uploadedFile.Error -eq $Null)
            {
                Write-Host "Upload of $($uploadedFile.FileName) succeeded"
            }
            else
            {
                Write-Host (
                    "Upload of $($uploadedFile.FileName) failed: $($uploadedFile.Error.Message)")
            }
        }
    }
finally
{
    $session.Dispose()
}