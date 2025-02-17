# Default Domain Policy

Policies
    Windows Settings
        Security Settings
            Account Policies/Password Policy
                Enforce password history 24 passwords remembered        OK
                Maximum password age 37201 days                         ok
                Minimum password age 1 days                             OK
                Minimum password length 5 characters                    14                                
                Password must meet complexity requirements Disabled     Enable
                Store passwords using reversible encryption Disabled    OK

            Account Policies/Account Lockout Policy
1.2.1                Account lockout duration 5 minutes 
1.2.2                Account lockout threshold 5 invalid logon attempts 
                Reset account lockout counter after 5 minutes 

            Account Policies/Kerberos Policy
                Enforce user logon restrictions Enabled 
                Maximum lifetime for service ticket 600 minutes 
                Maximum lifetime for user ticket 10 hours 
                Maximum lifetime for user ticket renewal 7 days 
                Maximum tolerance for computer clock synchronization 5 minutes 

            Local Policies/Security Options
                Network Access
                    Network access: Allow anonymous SID/Name translation Disabled 
                Network Security
                    Network security: Do not store LAN Manager hash value on next password change Enabled 
                    Network security: Force logoff when logon hours expire Disabled 

            Public Key Policies/Encrypting File System
                Certificates
                    Issued To Issued By Expiration Date Intended Purposes 
                    wubeaz wubeaz 1/22/2125 8:33:06 AM File Recovery 

