$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName   = 'pgadmin4'
$toolsDir      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url           = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.24/windows/pgadmin4-4.24-x86.exe' # download url
$url64         = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.24/windows/pgadmin4-4.24-x64.exe'
$checksum      = '7a8911f17f451ba73727626bbbfd80f93f95ec2f6803bbe56949c973b1987218'
$checksum64    = '4737db64744da399c1c9b0a16a16c6eb2e357f6b6401b46dcd6fd7ca94c4d4ca'
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
