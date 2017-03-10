# stop on all errors
$ErrorActionPreference = 'Stop';

$packageName   = 'sandcastle' # arbitrary name for the package, used in messages
$versionNumber = '{{PackageVersion}}'
$url           = '{{DownloadUrl}}' # download url
$checksum      = "{{Checksum}}"

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$zipFile = Join-Path $toolsDir ('SHFBInstaller_v' + $versionNumber + '.zip')
$zipDir = Join-Path $toolsDir ('SHFBInstaller_v' + $versionNumber)

Get-ChocolateyWebFile "$packageName" "$zipFile" "$url" `
                      -Checksum "$checksum" -ChecksumType 'sha256'
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
$vsix = Join-Path $zipDir "InstallResources\SHFBVisualStudioPackage.vsix"
$vsixUrl = "file:///" + $(Convert-Path $vsix).Replace("\", "/")

# Install-ChocolateyVsixPackage doesn't let us provide a list of supported versions for a package, unfortunately
# Check for each version supported by the Sandcastle tools VSIX and call the function repeatedly as needed
if ($env:VS100COMNTOOLS -And (Test-Path $env:VS100COMNTOOLS -PathType Container)) {
  Install-ChocolateyVsixPackage "$packageName" "$vsixUrl" -VsVersion 10
}
if ($env:VS110COMNTOOLS -And (Test-Path $env:VS110COMNTOOLS -PathType Container)) {
  Install-ChocolateyVsixPackage "$packageName" "$vsixUrl" -VsVersion 11
}
if ($env:VS120COMNTOOLS -And (Test-Path $env:VS120COMNTOOLS -PathType Container)) {
  Install-ChocolateyVsixPackage "$packageName" "$vsixUrl" -VsVersion 12
}
if ($env:VS140COMNTOOLS -And (Test-Path $env:VS140COMNTOOLS -PathType Container)) {
  Install-ChocolateyVsixPackage "$packageName" "$vsixUrl" -VsVersion 14
}
if ($env:VS150COMNTOOLS -And (Test-Path $env:VS150COMNTOOLS -PathType Container)) {
  Install-ChocolateyVsixPackage "$packageName" "$vsixUrl" -VsVersion 15
}

New-Item "$zipDir\SandcastleInstaller.exe.ignore" -Type file -Force | Out-Null
