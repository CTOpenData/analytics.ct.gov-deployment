# analytics.ct.gov Deployment Scripts

This is the main repository for deploying the project. It contains the scripts necessary to deploy analytics.ct.gov to CT’s servers.

There are two main entry points:
1. __deploy-site.ps1__
1. __deploy-reports.ps1__

## deploy_site.ps1
### Description
This script is run locally on a Windows machine connected to the VPN. The script clones the analytics.ct.gov repository, builds the project with bundler and jekyll, removing development files. It next opens a winscp connection, syncing the local copy of the website to the server, removing outdated files on the server.

### Requirements
1. ruby 2.4.3
1. bundler

### Usage
```powershell
.\deploy-site.ps1 -UserName "Username" -Password "Password" -HostIP "HostIP" -HostKey "Hostkey"
```

## deploy_reports.ps1
### Description
This script is run locally on a Windows machine connected to the VPN. The script creates a WinSCP connection using the Powershell DLL module. With this session, it uploads the `.\tasks` folder of the analytics.ct.gov-deployment project. It then closes this WinSCP connection. Next, it creates an SSH tunnel to start a Powershell instance and run the `.\create_tasks.ps1` script on the server.

### Requirements
WinSCPnet.dll

### Usage
```powershell
.\deploy_site.ps1 -UserName "Username" -Password "Password" -HostIP "HostIP" -HostKey "Hostkey" -ProjectLocation "ProjectLocation" -OutputDirectory "OutputDirectory"
```
### Parameters descriptions 
**ProjectLocation**: the location of keys, env scripts, and reports. Should be one of:
`\analytics-backend` OR `E:\???\wwwroot\analytics-backend`

**OutputDirectory**: the location of where the scripts place the reports. Should be one of:
`\analytics\data` OR `E:\???\wwwroot\analytics\data`

## Other scripts

### tasks\create_tasks.ps1
#### Description
This script is run on the remote machine. It is invoked by the `deploy_reports.ps1` script. It starts by running `teardown_tasks.ps1` to clean up previously deployed tasks. It then runs npm install to install all the node dependencies for the analytics reports. It next invokes `schtasks` several times with the different frequencies. The scheduled task runs a powershell instance that immediately invokes the `task.ps1` script with supplied parameters.

#### Usage
Note: This script is not invoked directly by the user.
```powershell
.\create_tasks.ps1 -ProjectLocation "ProjectLocation" -OutputDirectory "OutputDirectory"
```

#### Requirements (on server)
1. Powershell
1. Schtasks
1. Node, npm, npx

### task\tasks.ps1
#### Description 
This script is run on the remote machine. It is invoked by the scheduled tasks (created by “create_tasks.ps1”). This script sources the environment variables for the CT context. It then creates the output directory, if it doesn’t already exist. Finally, it runs the analytics reporter via npx.

#### Usage
Note: This script is not invoked directly by the user.
```powershell
.\task.ps1 -ProjectLocation "ProjectLocation" -OutputDirectory "OutputDirectory" -Frequency "Frequency"
```

#### Requirements (on server)
1. Node, npm, npx