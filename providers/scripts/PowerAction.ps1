
try {
    # set shutdown on powerbutton on battery
    powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3
    # set shutdown on powerbutton plugged in
    powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3
}
catch {
    Write-Host "An error occurred: continuing"
}
Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" -Name "shutdownwithoutlogon" -Value 1
try {
    Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\PolicyManager\default\Start\HideRestart" -Name "value" -Value 0 -ErrorAction Stop
    Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\PolicyManager\default\Start\HideShutDown" -Name "value" -Value 0 -ErrorAction Stop
}
catch {
    Write-Host "An error occurred: continuing"
}
