# Netrunner

* fw / 192.168.2.100: 


* haas.local:
    * Computers: 
        * dc_haas (haas01 / 172.17.2.1): 
            * adds
        * srv01 (bran.haas.local / 172.17.2.10):
            * mssql (haas.local\drafter)
            * mssql_reporting
            * users:
                * LA_jubeaz / Zaebuj12345+-
    * gmsa:
        * none
    * users:
        * lowpriv (/ jubeaz)
        * hubeaz (/ jubeaz)
        * jubeaz (/ jubeaz)
* research.haas.local:
    * Computers: 
        * dc_rsc (rsc01 / 72.16.3.1): 
            * adds
        * srv01 (fenris.research.haas.local / 72.16.3.10):
            * sccm
            * iis
            * mssql (research.haas.local\ichi$)
            * mssql_reporting
            * users:
                * LA_jubeaz / Zaebuj12345+-
        * ws01 (architect.research.haas.local / 72.16.3.20):
            * sccm_console
            * mssql_ssms
            * users:
                * LA_jubeaz / Zaebuj12345+-
    * gmsa:
        * ichi (mssql on fenris)
    * users:
        * lowpriv (/ jubeaz)
        * rubeaz (/ jubeaz)
* weyland.local
    * Computers: 
        * dc_wld (wld01 / 172.17.1.1): 
            * adds
        * srv01 (archer.weyland.local / 172.17.1.10)
            * mssql (NT AUTHORITY\NETWORK SERVICE)
            * users:
                * LA_jubeaz / Zaebuj12345+-
    * gmsa:
        * none
    * users:
        * lowpriv (/ jubeaz)
        * wubeaz (/ jubeaz)

# netrunner_base


# netrunner