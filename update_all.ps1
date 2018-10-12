Import-Module au

Get-AUPackages | ForEach-Object {
  $packageName = $_.Name

  # Deal with sticky global functions by deleting them before each package run
  Remove-Item Function:\au_GetLatest -ErrorAction SilentlyContinue
  Remove-Item Function:\au_SearchReplace -ErrorAction SilentlyContinue
  Remove-Item Function:\au_BeforeUpdate -ErrorAction SilentlyContinue
  Remove-Item Function:\au_AfterUpdate -ErrorAction SilentlyContinue

  # Move into the package directory and then run the update script for it
  Push-Location $_
  Write-Host $packageName
  try {
    . $PSScriptRoot\$packageName\update.ps1
  }
  catch {
    Write-Error $error[0]
  }
  Pop-Location
}
