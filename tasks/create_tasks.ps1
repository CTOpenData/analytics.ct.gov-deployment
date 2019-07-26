# Realtime task (every minute)
& "SCHTASKS" `
/Create `
/SC MINUTE `
/MO 1 `
/TR "POWERSHELL $LOCATION\analytics\realtime.ps1" `
/TN Analytics-Realtime

# Daily tasks