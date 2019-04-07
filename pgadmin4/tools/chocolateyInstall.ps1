$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'pgadmin4'
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url         = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.4/windows/pgadmin4-4.4-x86.exe' # download url
$checksum    = '371f341f3a629f1691a3876085834cfd53360abe72543cd27ae4eec6d8f9676b'
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
