function createFile {
  $filename = Get-Date -Format "yyyy-MM-dd"
  New-Item -Path "C:\Verify" -Name $filename -ItemType "File" -Force | Out-Null
}

function deleteOld {
  Write-Host "Deleting old files..."
  $folder="C:\Verify"
  $currentYear = Get-Date -Format "yyyy"
  $currentYearInt = [int]$currentYear
  $currentMonth = Get-Date -Format "MM"
  $currentMonthInt = [int]$currentMonth

  Get-ChildItem $folder | Foreach-Object {
    $filename = $_.BaseName
    $filepath = $_.FullName
    $fileYear = $filename.Substring(0,4)
    $fileYearInt = [int]$fileYear
    $fileMonth = $filename.Substring(5,2)
    $fileMonthInt = [int]$fileMonth

    #Delete files older than a year old.
    if(($currentYearInt - $fileYearInt) -gt 0) {
      Write-Host "Deleting: $filepath"
      Remove-Item $filepath
    }
    #Delete files based on month (change the 1 to a higher number to keep more files)
    if(($currentMonthInt - $fileMonthInt -gt 1)) {
      Write-Host "Deleting: $filepath"
      Remove-Item $filepath
    }
  }
}

if(Test-Path -Path "C:\Verify") {
  createFile
  deleteOld
}
else {
  New-Item -Path "C:\" -Name "Verify" -ItemType "Directory" | Out-Null
  createFile
}
