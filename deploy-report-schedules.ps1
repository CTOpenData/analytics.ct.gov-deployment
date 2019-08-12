param (
    [Parameter(Mandatory=$true)][string]$UserName,
    [Parameter(Mandatory=$true)][string]$Password,
    [Parameter(Mandatory=$true)][string]$HostIP,
    [Parameter(Mandatory=$true)][string]$HostKey,
    [Parameter(Mandatory=$true)][string]$ProjectLocation,
    [Parameter(Mandatory=$true)][string]$OutputDirectory
)

ssh $UserName@$HostIP "powershell .\$ProjectLocation\create_tasks.ps1 -ProjectLocation $ProjectLocation -OutputDirectory $OutputDirectory -UserName $UserName -Password $Password"