#Requires -Version 5.1

<#
  .SYNOPSIS
    This is a basic script to copy files/folders from one user to another using Robocopy.
    
    The following folders are included:
      Desktop
      Documents
      Downloads
      Music
      Pictures
      Videos
  
  .PARAMETER
    copyOrMove - $env:copyOrMove
    If "Copy" is selected, keeps original data intact.
    If "Move" is selected, moves data after verifying it's been copied.
    
    NOTE: If you run this and copy the data, and then run it a second time to move the data, 
    it will not get rid of files that have already been copied.
    
  .PARAMETER
    sourceUserFolder - $env:sourceUserFolder
    Name of the user folder you want to copy from. Usually the same as username, but sometimes
    the username is renamed (or the folder is renamed.) This script uses the folder name itself.
    
  .PARAMETER
    destinationUserFolder - $env:destinationUserFolder
    Name of the destination folder you want to copy to. Usually the same as username, but sometimes
    the username is renamed (or the folder is renamed.) This script uses the folder name itself.
  
  .NOTES
    Author:Anthony Lombardo
#>

BEGIN {
  Write-Output ''
  $sourcePath = "$($env:SystemDrive)\Users\$($env:sourceUserFolder)"
  $destinationPath = "$($env:SystemDrive)\Users\$($env:destinationUserFolder)"
  
  $sourceTest = Test-Path -Path $sourcePath
  $destinationTest = Test-Path -Path $destinationPath
  
  if(!$sourceTest -or !$destinationTest) { 
    Write-Output 'One or both of the folder(s) does not exist:'
    Write-Output "$($sourcePath) exists: $sourceTest"
    Write-Output "$($destinationPath) exists: $destinationFolder"
    
    exit 1
  }
}

PROCESS{
  if($env:copyOrMove -eq 'Copy') {
    Write-Output 'Attempting to copy Desktop...'
    robocopy $sourcePath\Desktop $destinationPath\Desktop /mt:16 /e
    
    Write-Output 'Attempting to copy Documents...'
    robocopy $sourcePath\Documents $destinationPath\Documents /mt:16 /e
    
    Write-Output 'Attempting to copy Downloads...'
    robocopy $sourcePath\Downloads $destinationPath\Downloads /mt:16 /e
    
    Write-Output 'Attempting to copy Music...'
    robocopy $sourcePath\Music $destinationPath\Music /mt:16 /e
    
    Write-Output 'Attempting to copy Pictures...'
    robocopy $sourcePath\Pictures $destinationPath\Pictures /mt:16 /e
    
    Write-Output 'Attempting to copy Videos...'
    robocopy $sourcePath\Videos $destinationPath\Videos /mt:16 /e
  }
  
  if($env:copyOrMove -eq 'Move') {
    Write-Output 'Attempting to move Desktop...'
    robocopy $sourcePath\Desktop $destinationPath\Desktop /mt:16 /e /move
    
    Write-Output 'Attempting to move Documents...'
    robocopy $sourcePath\Documents $destinationPath\Documents /mt:16 /e /move
    
    Write-Output 'Attempting to move Downloads...'
    robocopy $sourcePath\Downloads $destinationPath\Downloads /mt:16 /e /move
    
    Write-Output 'Attempting to move Music...'
    robocopy $sourcePath\Music $destinationPath\Music /mt:16 /e /move
    
    Write-Output 'Attempting to move Pictures...'
    robocopy $sourcePath\Pictures $destinationPath\Pictures /mt:16 /e /move
    
    Write-Output 'Attempting to move Videos...'
    robocopy $sourcePath\Videos $destinationPath\Videos /mt:16 /e /move
  }
}

END{
  Write-Output 'Script finished.'
}
