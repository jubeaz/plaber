Function Compare-FindingList{
    param (
        [Parameter(Mandatory=$true)]
        [array]$FindingList,
        [Parameter(Mandatory=$true)]
        [array]$CriteriaList
    )
    foreach ($Criteria in $CriteriaList){
        $tmp = $FindingList | Where-Object -FilterScript {$_.ID -eq $Criteria.ID}
        If ($tmp.Length -ne 1) {
            return $false
        }       
    }
    foreach ($Finding in $FindingList){
        $tmp = $CriteriaList | Where-Object -FilterScript {$_.ID -eq $Finding.ID}
        If ($tmp.Length -ne 1) {
            return $false
        }       
    }
    return $true
}

Function New-MergedFindingsList{
    param (
        [Parameter(Mandatory=$true)]
        [array]$FindingList,
        [Parameter(Mandatory=$true)]
        [array]$CriteriaList
    )

    $Merged = @()
    foreach ($Criteria in $CriteriaList){
        $tmp = $FindingList | Where-Object -FilterScript {$_.ID -eq $Criteria.ID}
        If ($tmp.Length -ne 1) {
            Throw "$($Criteria.ID) not found in FindingList"
        }
        foreach ($property in $tmp.PSObject.Properties) {
            if ($Criteria.PSObject.Properties[$property.Name] -eq $null) {
                #write-host "Adding property $($property.Name) with value $($property.Value)"
                $Criteria | Add-Member NoteProperty $property.Name  $property.Value
            }
            else {
                #write-host "Setting $($property.Name)  $($property.Value)"
                $Criteria.PSObject.Properties[$property.Name].Value =   $property.Value
            }
        }
        $Merged += $Criteria
        #write-host $Criteria
    }
    return $Merged
}

Function Get-FilteredFindingList {
    param (
        [Parameter(Mandatory=$false)]
        [scriptblock]$Filter,
        [Parameter(Mandatory=$true)]
        [String]$FileFindingList,
        [Parameter(Mandatory=$true)]
        [String]$FileCriteria
    )
    #$FindingList = Import-Csv -Path $FileFindingList -Delimiter ","
    $csvContent = Invoke-WebRequest -Uri $FileFindingList -UseBasicParsing
    $csvString = $csvContent.Content
    $FindingList = ConvertFrom-Csv -InputObject $csvString
    $CriteriaList = Import-Csv -Path $FileCriteria -Delimiter ","
    $CompareResult = Compare-FindingList -FindingList $FindingList -CriteriaList $CriteriaList
    if ($CompareResult -eq $false){
        Throw  "Missing findings"
    } 
    $ResultList = New-MergedFindingsList -FindingList $FindingList -CriteriaList $CriteriaList
    If ($Filter) {
        $ResultList = $ResultList | Where-Object -FilterScript $Filter
        If ($ResultList.Length -eq 0) {
            Throw  "Your filter did not return any results, please adjust the filter so that HardeningKitty has something to work with."
        }
    }
    $CriteriaList = @()
    foreach ($Result in $ResultList){
        $tmp = $FindingList | Where-Object -FilterScript {$_.ID -eq $Result.ID}
        If ($tmp.Length -ne 1) {
            Throw "$($Criteria.ID) not found in FindingList"
        }
        $CriteriaList += $tmp
    }
    return $CriteriaList
}


Function New-FilteredFindingList {
    param (
        [Parameter(Mandatory=$false)]
        [scriptblock]$Filter,
        [Parameter(Mandatory=$true)]
        [String]$FileFindingList,
        [Parameter(Mandatory=$true)]
        [String]$FileCriteria,
        [Parameter(Mandatory=$true)]
        [String]$FileOut
    )
    $fl = Get-FilteredFindings -Filter $Filter -FileFindingList $FileFindingList -FileCriteria $FileCriteria
    $fl | Export-CSV $FileOut -NoTypeInformation
}
#$Filter = { $_.DC -eq "Y" -and $_.DEFAULT -eq "APPLY" } 
#$Filter = { $_.MBR -eq "Y" -and $_.DEFAULT -eq "APPLY" } 

#$FileFindingList = './finding_list_cis_microsoft_windows_server_2022_22h2_3.0.0_machine/finding_list_cis_microsoft_windows_server_2022_22h2_3.0.0_machine.csv'
$FileFindingList = 'https://github.com/scipag/HardeningKitty/raw/refs/heads/master/lists/finding_list_cis_microsoft_windows_server_2022_22h2_3.0.0_machine.csv'
$FileCriteria = './cis_microsoft_windows_server_2022_22h2_3.0.0_machine/critera.csv'
$Filter = { $_.DEFAULT -ne "APPLY" } 
$Filter = { $_.MBR -eq "Y" -and $_.DEFAULT -eq "APPLY" -and $_.Category -eq "User Rights Assignment"}
$Filter = { $_.STD_ALONE -eq "Y" -and $_.DEFAULT -eq "APPLY" -and $_.ID -ne "2.2.22" -and $_.ID -ne "2.2.27"}
$FileOut= './cis_microsoft_windows_server_2022_22h2_3.0.0_machine/findings_STD_ALONE.csv'
New-FilteredFindingList -Filter $Filter -FileFindingList $FileFindingList -FileCriteria $FileCriteria -FileOut $FileOut
