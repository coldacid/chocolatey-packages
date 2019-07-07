$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'pgadmin4'
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url         = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.10/windows/pgadmin4-4.10-x86.exe' # download url
$checksum    = '36c7e926243e558e43070b2ba362acc7e5508b77365f9d7cba52ddc81b1175a8'
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
