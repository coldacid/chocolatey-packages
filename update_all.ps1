Import-Module au

Get-AUPackages | ForEach-Object {
  $packageName = $_.Name
  $packageData = $null
  $packageErr = $null

  # Deal with sticky global functions by deleting them before each package run
  Remove-Item Function:\au_GetLatest -ErrorAction SilentlyContinue
  Remove-Item Function:\au_SearchReplace -ErrorAction SilentlyContinue
  Remove-Item Function:\au_BeforeUpdate -ErrorAction SilentlyContinue
  Remove-Item Function:\au_AfterUpdate -ErrorAction SilentlyContinue

  # Move into the package directory and then run the update script for it
  Push-Location $_
  Write-Host $packageName
  try {
    $packageData = . $PSScriptRoot\$packageName\update.ps1
    if ($packageData -eq $null) {
      throw $(New-Object System.Exception -Arguments "No package data returned")
    }
  }
  catch {
    $packageErr = $error[0]
  }
  if ($packageErr -eq $null -and $packageData.Error -ne $null) {
    $packageErr = $packageData.Error
  }

  if ($packageErr -ne $null) {
    Write-Error $packageErr
    Pop-Location
    continue
  }

  # Check if package has been updated, and push the new version if so
  $oldVersion = [version]$packageData.RemoteVersion
  $newVersion = [version]$packageData.NuspecVersion

  if ($newVersion -gt $oldVersion) {
    cpush ${packageName}$($packageData.NuspecVersion).nupkg
    git add .
    git commit -m "${packageName}: Update to $($packageData.NuspecVersion)"
  }

  Pop-Location
}
