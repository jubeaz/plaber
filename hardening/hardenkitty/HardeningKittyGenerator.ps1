Function Compare-FindingList{
    param (
        [Parameter(Mandatory=$true)]
        [array]$FindingList,
        [Parameter(Mandatory=$true)]
        [array]$CriteriaList
    )
    foreach ($Criteria in $CriteriaList){
        $tmp = $FindingList | Where-Object -FilterScript {$_.ID -eq $Criteria.ID}
        If ($tmp -eq $null -or ($tmp -is [array] -and $tmp.Length -gt 1)) {
          Throw  "Problem with findings $($Criteria.ID) either null or duplicate"
        }       
    }
    foreach ($Finding in $FindingList){
        $tmp = $CriteriaList | Where-Object -FilterScript {$_.ID -eq $Finding.ID}
        If ($tmp -eq $null -or ($tmp -is [array] -and $tmp.Length -gt 1)) {
          Throw  "Problem with critera $($Finding.ID) either null or duplicate"
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
        Throw  "List are not equals"
    } 
    $ResultList = New-MergedFindingsList -FindingList $FindingList -CriteriaList $CriteriaList
    $SizeIn = $ResultList.Length
    If ($Filter) {
        $ResultList = $ResultList | Where-Object -FilterScript $Filter
        If ($ResultList -eq $null -or $ResultList.Length -eq 0) {
          Throw  "Search filter return nothing"
        } 
    }
    $FilteredCount = $SizeIn - $ResultList.Length
    Write-Host "Number of findings filtered out: $($SizeIn - $ResultList.Length)"
    $CriteriaList = @()
    foreach ($Result in $ResultList){
        $tmp = $FindingList | Where-Object -FilterScript {$_.ID -eq $Result.ID}
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
    $fl = Get-FilteredFindingList -Filter $Filter -FileFindingList $FileFindingList -FileCriteria $FileCriteria
    $fl | Export-CSV $FileOut -NoTypeInformation
}

