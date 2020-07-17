$outputFile = "C:\Output\AD_UserDetails.csv" 
Add-Content -Path $outputFile -Value "userprincipalName,SamAccountName,Givenname,country,state,office,Division,department"
 
# To get the UPN using Email Ids of users from whole AD forest
$objForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
$DomainList = @($objForest.Domains | Select-Object Name)
$Domains = $DomainList | foreach {$_.Name}
$Users = Import-CSV C:\Input\UserList.csv
#Act on each domain
foreach($Domain in ($Domains))
{
    Write-Host "Checking $Domain" -fore red
    Foreach($Email in ($Users.EMail))
    {

      $usersInfo = Get-ADUser -filter {Mail -eq $Email} -Server $domain -properties Mail,country,state,office,Division,department  | select  userprincipalName,SamAccountName,Givenname,country,state,office,Division,department 
      $userprincipalName= $usersInfo.userprincipalName
      $SamAccountName = $usersInfo.SamAccountName
       If($SamAccountName -ne $null -and $SamAccountName -ne "")
        {
          $Givenname = $usersInfo.Givenname
          $country = $usersInfo.country
          $state = $usersInfo.state
          $office = $usersInfo.office
          $Division = $usersInfo.Division
          $department = $usersInfo.department
          Add-Content -Path $outputFile -Value "$userprincipalName,$SamAccountName,$Givenname,$country,$state,$office,$Division,$department"
      }
    
    }
    
}
