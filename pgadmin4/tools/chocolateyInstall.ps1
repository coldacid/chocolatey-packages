$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'pgadmin4'
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url         = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v3.3/windows/pgadmin4-3.3-x86.exe' # download url
$checksum    = '59b1c3034fcf4161154496e3579ab0fbe5f5d00072b6be3a1a60842e8ea86bc1'
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
