$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. $toolsPath\helpers.ps1

# stop on all errors
$ErrorActionPreference = 'Stop';

$packageName   = 'sandcastle' # arbitrary name for the package, used in messages
$versionNumber = '2019.8.24.0'
$url           = 'https://github.com/EWSoftware/SHFB/releases/download/v2019.8.24.0/SHFBInstaller_v2019.8.24.0.zip' # download url
$checksum      = '97f97b6d70aa6ebfdfd36db3442ef54768c169076fba45ac5129e38b82759d9c'
$checksumType  = 'sha256'

$chocTempDir   = Join-Path $env:TEMP "chocolatey"
$tempDir       = Join-Path $chocTempDir "$packageName"

$zipFile = Join-Path $tempDir ('SHFBInstaller_v' + $versionNumber + '.zip')
$zipDir = Join-Path $toolsPath ('SHFBInstaller_v' + $versionNumber)

Get-ChocolateyWebFile "$packageName" "$zipFile" "$url" `
                      -Checksum "$checksum" -ChecksumType "$checksumType"
Get-ChocolateyUnzip "$zipFile" "$zipDir"

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'MSI' # only one of these: exe, msi, msu
  file           = $(Join-Path $zipDir "InstallResources\SandcastleHelpFileBuilder.msi")

  silentArgs     = '/quiet'
  validExitCodes = @(0, 3010, 1641) # please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx
  softwareName   = 'Sandcastle*' #ensure this is the value in the registry
}
Install-ChocolateyInstallPackage @packageArgs

# Install-ChocolateyVsixPackage requires a URL, so build one out of the file path
$vsix = Join-Path $zipDir "InstallResources\SHFBVisualStudioPackage_VS2015AndLater.vsix"
$vsixUrl = "file:///" + $(Convert-Path $vsix).Replace("\", "/")

# Install-ChocolateyVsixPackage doesn't let us provide a list of supported versions for a package, unfortunately
# Check for each version supported by the Sandcastle tools VSIX and call the function repeatedly as needed
Get-VisualStudio | Where-Object { $_.installationVersion.Major -ge 14 } | ForEach-Object {
  $vsver = $_.installationVersion.ToString(2)
  Write-Host "Installing VSIX package for Visual Studio $vsver"

  if ( $_.installationVersion.Major -ge 15 ) {
    $vssku = Split-Path $_.installationPath -Leaf
    $vsixInstaller = Join-Path $_.installationPath 'Common7\IDE\VSIXInstaller.exe'

    # Otherwise VSIXInstaller.exe exits with error code 2003: NoApplicableSKUsException
    if ( $_.installationVersion.Major -eq 15 ) { $vsver = '15.0' }

    Write-Host "    SKU is '$vssku'"
    Write-Host "    Installation path is " $_.installationPath

    $exitCode = Install-VsixEXT "$vsixInstaller" "$vsix" "$vsver" "$vssku"
    if ($exitCode -eq 2004) { #2004: Blocking Process (need to close VS)
      throw "A process is blocking the installation of the Sandcastle extension for " + $_.displayName + ". Please close all instances and try again."
    }
    if ($exitCode -gt 0 -and $exitCode -ne 1001) { #1001: Already installed
      throw "There was an error installing the Sandcastle extension for " + $_.displayName + ". The exit code returned was $exitCode."
    }
  } elseif ( $_.installationVersion.Major -eq 14 ) {
    Install-ChocolateyVsixPackage "$packageName" "$vsixUrl" -VsVersion 14
  }
}

New-Item "$zipDir\SandcastleInstaller.exe.ignore" -Type file -Force | Out-Null
