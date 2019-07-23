# analytics.ct.gov scripts

## Requirements
* ruby 2.4.3
* bundler

## Scripts

### __deploy.ps1__
Contains the steps for deploying analytics.ct.gov
__Usage__
To get information login using winscp and then click on Sessions > Generate Session URL/Code
```
.\deploy.ps1 -UserName "Username" -Password "Password" -HostIP "HostIP" -HostKey "Hostkey"
```