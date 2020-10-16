$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName   = 'pgadmin4'
$toolsDir      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url           = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.27/windows/pgadmin4-4.27-x86.exe' # download url
$url64         = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.27/windows/pgadmin4-4.27-x64.exe'
$checksum      = '3906517eb0c1705762e8bcd5542dabd79c7bed9517065ca6a54d3e0eab31f548'
$checksum64    = '44812137c946627e637b06f4c0d9dc43d9a54d7bdaa1c30e7330307d9b118abd'
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
