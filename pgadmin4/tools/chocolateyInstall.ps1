$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName   = 'pgadmin4'
$toolsDir      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url           = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.26/windows/pgadmin4-4.26-x86.exe' # download url
$url64         = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.26/windows/pgadmin4-4.26-x64.exe'
$checksum      = 'e377fc80d1ada7e40ea56411df2e209705025fe76f54840f81ce3a76eaa15f0c'
$checksum64    = '2374e8fe59a1b28f88b3fd653e70ad9be5334a20b3a03c4e4ab8b78edd77db42'
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
