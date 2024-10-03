#Requires -Version 5.1

<#
  .SYNOPSIS
  Deletes GCPW user accounts from Windows computers. First name and last name are case insensitive. 
  If audit is check, the script will return what it will do if it's unchecked.
  
  Accounts for usernames with the following formats:
  
  First name initial + Last name (alombardo@domain.com)
  First name + Last name initial (lombardoa@domain.com)
  First name + Period + Last name (anthony.lombardo@domain.com)
  
  If you need to add additional username formats, add them to line 42.
  
  .PARAMETER
    $env:firstName
    First name of user (not case-sensitive, script accounts for case and whitespace)
    
    $env:lastName
    Last name of user (not case-sensitive, script accounts for case and whitespace)
    
    $env:audit
    If checked, will show you what will happen if it is run.
  
  .NOTES
    Author:Anthony Lombardo
#>

#Initialize global variables, helper functions, etc.
BEGIN {
  Write-Output ''
  #Cleanup script variables, removes any leading/trailing whitespace and changes to all lowercase.
  $first = $env:firstName.ToLower()
  $first = $first.TrimStart()
  $first = $first.TrimEnd()
  $last = $env:lastName.ToLower()
  $last = $last.TrimStart()
  $last = $last.TrimEnd()
  
  #Usernames to search for
  $usernames = ($first + '.' + $last), ($first[0] + $last), ($first + $last[0])
  
  Write-Output 'Checking for these users:'
  Write-Output '----------------------------------------------------------------------------------------------------'
  Write-Output $usernames
  Write-Output ''
}

#Main body of script, do most stuff here.
PROCESS {
  #Get a list of all user profiles
  $userProfiles = Get-CimInstance Win32_UserProfile | Where-Object { $_.Special -ne $true }
  
  Write-Output 'These are all of the profiles on the computer:'
  Write-Output '----------------------------------------------------------------------------------------------------'
  
  $profilesToDelete = @()
  
  foreach($profile in $userProfiles) {
    $trimmed = $profile.LocalPath.Split('_')[0]
    $trimmed = $trimmed.Split('\')[2]
    
    Write-Output "Trimmed Username: $trimmed"
    Write-Output "User Profile Path: $($profile.LocalPath)"
    Write-Output "SID: $($profile.SID)"
    if($usernames.Contains($trimmed)){ 
      Write-Output 'Match found!'
      $profilesToDelete += $profile
    }
    Write-Output ''
  }
  
  if($env:audit -eq $true) {
    Write-Output 'These profiles will be deleted if you run this with Audit unchecked:'
    Write-Output '----------------------------------------------------------------------------------------------------'
    foreach($profile in $profilesToDelete) {
      $trimmed = $profile.LocalPath.Split('_')[0]
      $trimmed = $trimmed.Split('\')[2]
    
      Write-Output "Trimmed Username: $trimmed"
      Write-Output "User Profile Path: $($profile.LocalPath)"
      Write-Output "SID: $($profile.SID)"
    }
  }
  if($env:audit -eq $false) {
    foreach($profile in $profilesToDelete) {
      Write-Host "Deleting profile: $($profile.LocalPath)"
      Remove-LocalUser -SID $profile.SID
      Remove-CimInstance -InputObject $profile
    }
  }
}

#Cleanup and exit codes. 0 = Sucess, Non-Zero = Failure
END{}
