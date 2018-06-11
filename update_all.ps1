Import-Module au

Get-AUPackages | ForEach-Object {
  $packageName = $_.Name

  # Deal with sticky global functions by deleting them before each package run
  rm Function:\au_GetLatest
  rm Function:\au_SearchReplace
  rm Function:\au_BeforeUpdate
  rm Function:\au_AfterUpdate

  # Move into the package directory and then run the update script for it
  pushd $_
  Write-Host $packageName
  try {
    . $PSScriptRoot\$packageName\update.ps1
  }
  catch {
    Write-Error $error[0]
  }
  popd
}
