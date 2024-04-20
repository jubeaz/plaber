
try {
    # set shutdown on powerbutton on battery
    powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3
    # set shutdown on powerbutton plugged in
    powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3
}
catch {
    Write-Host "An error occurred while setting shutdown on powerbutton"
}

# Enabling immediate shutdown of a virtual server with logged in users.
if ((Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\windows").PSObject.Properties.Name -contains "ShutdownWarningDialoTimeout") {
    try {
        Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\windows" -Name "ShutdownWarningDialoTimeout" -value 1 
    } catch {
        Write-Host "An error occurred while trying to Enabling immediate shutdown of a virtual server with logged in users." 
    }
} else {
    try {
        New-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\windows" -Name "ShutdownWarningDialoTimeout" -value 1
    } catch {
        Write-Host "An error occurred while trying to (create) Enabling immediate shutdown of a virtual server with logged in users." 
    }
}

# Allow system to be shut down without having to log on
if ((Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system").PSObject.Properties.Name -contains  "shutdownwithoutlogon") {
    try {
        Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" -Name "shutdownwithoutlogon" -value 1 
    } catch {
        Write-Host "An error occurred while trying to Allow system to be shut down without having to log on" 
    }
} else {
    try {
        New-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" -Name "shutdownwithoutlogon" -value 1
    } catch {
        Write-Host "An error occurred while trying to (create) Allow system to be shut down without having to log on" 
    }
}


# Enabling Default Reply
if (-not (Test-Path -path "HKLM:SYSTEM\CurrenctControlSet\Control\Error Message Instrument")) {
    try {
        New-Item -Path "HKLM:SYSTEM\CurrenctControlSet\Control" -Name "Error Message Instrument" -Force 
    } catch {
        Write-Host "An error during creation : HKLM:SYSTEM\CurrenctControlSet\Control\Error Message Instrument" 
    }
} 
if ((Get-ItemProperty -Path "HKLM:SYSTEM\CurrenctControlSet\Control\Error Message Instrument").PSObject.Properties.Name -contains  "EnableDefaultReply") {
    try {
        Set-ItemProperty -Path "HKLM:SYSTEM\CurrenctControlSet\Control\Error Message Instrument" -Name "EnableDefaultReply" -value 1 
    } catch {
        Write-Host "An error occurred while trying to Enable Default Reply" 
    }
} else {
    try {
        New-ItemProperty -Path "HKLM:SYSTEM\CurrenctControlSet\Control\Error Message Instrument" -Name "EnableDefaultReply" -value 1
    } catch {
        Write-Host "An error occurred while trying to (create) Enable Default Reply" 
    }
}
