$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. $toolsPath\helpers.ps1

# stop on all errors
$ErrorActionPreference = 'Stop';

$packageName   = 'sandcastle' # arbitrary name for the package, used in messages
$versionNumber = '2022.2.6.0'
$url           = 'https://github.com/EWSoftware/SHFB/releases/download/v2022.2.6.0/SHFBInstaller_v2022.2.6.0.zip' # download url
$checksum      = 'c379fb876c06b32c50a73e822966c2d4a845efb2a4d7e96faa9c244de94a1065'
$checksumType  = 'sha256'

$chocTempDir   = Join-Path $env:TEMP "chocolatey"
$tempDir       = Join-Path $chocTempDir "$packageName"

$zipFile = Join-Path $tempDir ('SHFBInstaller_v' + $versionNumber + '.zip')
$zipDir = Join-Path $toolsPath ('SHFBInstaller_v' + $versionNumber)
$pkgDir = Join-Path $zipDir "InstallResources"

Get-ChocolateyWebFile "$packageName" "$zipFile" "$url" `
                      -Checksum "$checksum" -ChecksumType "$checksumType"
Get-ChocolateyUnzip "$zipFile" "$zipDir"

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'MSI' # only one of these: exe, msi, msu
  file           = $(Join-Path $pkgDir "SandcastleHelpFileBuilder.msi")

  silentArgs     = '/quiet'
  validExitCodes = @(0, 3010, 1641) # please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx
  softwareName   = 'Sandcastle*' #ensure this is the value in the registry
}
Install-ChocolateyInstallPackage @packageArgs

# Install-ChocolateyVsixPackage doesn't let us provide a list of supported versions for a package, unfortunately
# Check for each version supported by the Sandcastle tools VSIX and call the function repeatedly as needed
Get-VisualStudio | Where-Object { $_.installationVersion.Major -ge 15 } | ForEach-Object {
  $vsver = $_.installationVersion.ToString(2)
  Write-Host "Installing VSIX package for Visual Studio $vsver"

  $vssku = Split-Path $_.installationPath -Leaf
  $vsixInstaller = Join-Path $_.installationPath 'Common7\IDE\VSIXInstaller.exe'

  # Otherwise VSIXInstaller.exe exits with error code 2003: NoApplicableSKUsException
  if ( $_.installationVersion.Major -eq 15 ) { $vsver = '15.0' }

  # Set path for the VSIX package for the current Visual Studio version
  if ( $_.installationVersion.Major -le 16 ) { $vsix = Join-Path $pkgDir "SHFBVisualStudioPackage_VS2017And2019.vsix" }
  else { $vsix = Join-Path $pkgDir "SHFBVisualStudioPackage_VS2022AndLater.vsix" }

  Write-Host "    SKU is '$vssku'"
  Write-Host "    Installation path is " $_.installationPath

  $exitCode = Install-VsixEXT "$vsixInstaller" "$vsix" "$vsver" "$vssku"
  if ($exitCode -eq 2004) { #2004: Blocking Process (need to close VS)
    throw "A process is blocking the installation of the Sandcastle extension for " + $_.displayName + ". Please close all instances and try again."
  }
  if ($exitCode -gt 0 -and $exitCode -ne 1001) { #1001: Already installed
    throw "There was an error installing the Sandcastle extension for " + $_.displayName + ". The exit code returned was $exitCode."
  }
}

New-Item "$zipDir\SandcastleInstaller.exe.ignore" -Type file -Force | Out-Null
