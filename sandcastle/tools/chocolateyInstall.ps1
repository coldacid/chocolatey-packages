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

$vsix = Join-Path $zipDir "InstallResources\SHFBVisualStudioPackage.vsix"
$vsixUrl = "file:///" + $(Convert-Path $vsix).Replace("\", "/")
Install-ChocolateyVsixPackage "$packageName" "$vsixUrl" # it requires a URL :(
