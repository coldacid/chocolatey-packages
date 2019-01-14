$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'pgadmin4'
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url         = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.0/windows/pgadmin4-4.0-x86.exe' # download url
$checksum    = '993791c05d3a9af2fb67111c9fd8e8723ff2a7f0ead6ada033ec7b4dc18e5b38'
$checksumType= 'sha256'

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
}

Install-ChocolateyPackage @packageArgs
