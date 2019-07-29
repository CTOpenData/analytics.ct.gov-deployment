# Setup env variables
param (
  [Parameter(Mandatory=$true)][string]$UserName,
  [Parameter(Mandatory=$true)][string]$Password,
  [Parameter(Mandatory=$true)][string]$HostIP,
  [Parameter(Mandatory=$true)][string]$HostKey
  )
$CurrentDirectory = Get-Location



# Load WinSCP .NET assembly
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
    Write-Host "Uploadig files"
    $synchronizationResult = $session.SynchronizeDirectories(
      [WinSCP.SynchronizationMode]::Remote, "$CurrentDirectory\tasks", "\analytics", $True)
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
    $create_tasks = "Write-Host 'test'"
    $session.ExecuteCommand($create_tasks).Check()
}
finally
{
    $session.Dispose()
}

Pop-Location