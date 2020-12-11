$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName   = 'pgadmin4'
$toolsDir      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url           = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.29/windows/pgadmin4-4.29-x86.exe' # download url
$url64         = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.29/windows/pgadmin4-4.29-x64.exe'
$checksum      = '9d7945ac6e056ff507ef1919a6fbac7987b02d8f91b6b119a98f8da7624c691f'
$checksum64    = '9dd7ca8ea6d86165490908b3d213019a04e15567b2ba11c1f3c429533783da00'
$checksumType  = 'sha256'
$checksumType64= 'sha256'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  validExitCodes= @(0)

  softwareName  = 'pgAdmin 4'
  checksum      = $checksum
  checksumType  = $checksumType

  url64         = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
}

Install-ChocolateyPackage @packageArgs
