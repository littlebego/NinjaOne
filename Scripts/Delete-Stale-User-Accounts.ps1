#Requires -Version 5.1

<#
  .SYNOPSIS
    Does not delete 'Administrator' or 'gaia' which is the service account used by GCPW
  
  .PARAMETER
    $env:olderThan
    This variable determines the length of time to check against in days. 
    Any user profiles not used in this amount of time will be deleted.
    
    $env:audit
    If this box is checked, the script will return what it will do, but without actually doing it. 
    Useful since this script will delete user profile folders as well.
  
  .NOTES
    Author:Anthony Lombardo
#>

#Initialize global variables, helper functions, etc.
BEGIN {
  $thresholdDate = (Get-Date).AddDays(-$env:olderThan)
  Write-Output ''
}

#Main body of script, do most stuff here.
PROCESS {
  # Get a list of user profiles excluding the Administrator profile
  $userProfiles = Get-CimInstance Win32_UserProfile | Where-Object { $_.Special -ne $true } | Where-Object { $_.LocalPath -notmatch 'gaia' } | Where-Object { $_.LocalPath -notmatch 'Administrator' }
  
  Write-Output 'These are all the profiles on the computer (except Administrator and gaia)'
  Write-Output '----------------------------------------------------------------------------------------------------'
  foreach($profile in $userProfiles) {
    Write-Output "User profile path: $($profile.LocalPath)"
    Write-Output "Last use time: $($profile.LastUseTime)"
    Write-Output "SID: $($profile.SID)"
    Write-Output ''
  }
  
  # Filter profiles that haven't been updated in the specified time
  $profilesToDelete = $userProfiles | Where-Object { $_.LastUseTime -lt $thresholdDate }
  
  if($env:audit -eq $true) { 
    Write-Output 'These profiles will be deleted if you run this script with the audit box unchecked:'
    foreach($profile in $profilesToDelete) {
      Write-Output $profile.LocalPath
    }
  }
  if($env:audit -eq $false) {
    # Delete the identified profiles
    foreach ($profile in $profilesToDelete) {
      Write-Host "Deleting profile: $($profile.LocalPath)"
      Remove-LocalUser -SID $profile.SID
      Remove-CimInstance -InputObject $profile
    }
  }
}

#Cleanup and exit codes. 0 = Sucess, Non-Zero = Failure
END{}
