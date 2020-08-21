$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName   = 'pgadmin4'
$toolsDir      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url           = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.25/windows/pgadmin4-4.25-x86.exe' # download url
$url64         = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.25/windows/pgadmin4-4.25-x64.exe'
$checksum      = 'ebb6ccbc4ee60490664b916c0f69648ff2e1361e9cd72637820d2891f8a8bdca'
$checksum64    = '1e5285ab7a20fffc9eadd03cdb50aeeaa0b58f180226f2cd4e35cbba51d48d7a'
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
