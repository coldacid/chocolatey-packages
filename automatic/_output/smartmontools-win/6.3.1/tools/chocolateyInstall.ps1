try {
	$packageName = 'smartmontools-win'
	$installerType = 'exe'
	$url = 'http://en.netpower.fr/projects/smartmontools/smartmontools-win-6.3-1.zip'
	$silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
	$validExitCodes = @(0)
	$chocTempDir = Join-Path $env:TEMP "chocolatey"
	$tempDir = Join-Path $chocTempDir "$packageName"
	if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
	$zipfile = Join-Path $tempDir "$($packageName).zip"
	$unzipdir = Join-Path $tempDir "$($packageName).unzip"
	Write-Debug "Zipfile: [$zipfile]"
	if (-not (Test-Path $zipfile)) {
    Get-ChocolateyWebFile $packageName $zipfile $url $url64
  } else {
    Write-Debug "Zipfile is already downloaded."
  }
  $file = Join-Path $unzipdir (Get-ChildItem $unzipdir\*.exe -name)
  Write-Debug "Installer: $file"
  if (-not (Test-Path $file)) {
    Get-ChocolateyUnzip "$zipfile" $unzipdir $specificFolder $packageName | Out-Null
  } else {
    Write-Debug "Installer is already extracted."
  }
  Install-ChocolateyInstallPackage "$packageName" "$installerType" "$silentArgs" "$file" -validExitCodes "$validExitCodes"
  Write-ChocolateySuccess $packageName
} catch {
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}