Import-Module au

Get-AUPackages | ForEach-Object {
  $packageName = $_.Name
  $packageData = $null
  $packageErr = $null

  Write-Host `n

  # Deal with sticky global functions by deleting them before each package run
  Remove-Item Function:\au_GetLatest -ErrorAction SilentlyContinue
  Remove-Item Function:\au_SearchReplace -ErrorAction SilentlyContinue
  Remove-Item Function:\au_BeforeUpdate -ErrorAction SilentlyContinue
  Remove-Item Function:\au_AfterUpdate -ErrorAction SilentlyContinue

  # Move into the package directory and then run the update script for it
  Push-Location $_
  Write-Host "Updating $packageName"
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
    Write-Error "Failed to update ${packageName}: $packageErr"
  }
  # Check if package has been updated, and push the new version if so
  elseif ($packageData.Updated -eq $true) {
    # Deal with the version properties being wishy-washy about which is newer
    $nuVer = Get-Version $packageData.NuspecVersion
    $rmVer = Get-Version $packageData.RemoteVersion
    if ($rmVer -gt $nuVer) {
      $verString = $packageData.RemoteVersion
    } else {
      $verString = $packageData.NuspecVersion
    }

    Write-Host "Pushing ${packageName} ${verString} to Chocolatey"
    try {
      $packageFile = [System.String]::Join('.', $packageName, $verString, 'nupkg')
      choco push $packageFile
      if ($LastExitCode -ne 0) { throw "Choco push failed with exit code $LastExitCode" }
    }
    catch {
      $err = $error[0]
      Write-Error "Failed to push ${packageName} ${verString}: $err"
    }

    Write-Host "Committing ${packageName} changes to Git"
    git add .
    git commit -m "${packageName}: Update to ${verString}"
  }

  Pop-Location
}
