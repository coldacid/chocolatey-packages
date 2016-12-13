$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'pgadmin4'
$version     = "{{PackageVersion}}"
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url         = '{{DownloadUrl}}' # download url
$checksum    = "{{Checksum}}"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  validExitCodes= @(0)

  softwareName  = 'pgAdmin 4'
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
