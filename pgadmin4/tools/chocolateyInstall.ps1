$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'pgadmin4'
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url         = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v3.2/windows/pgadmin4-3.2-x86.exe' # download url
$checksum    = '749f1dd7836da05cf0fe2e9fc50dd5111614cde656ba722f983aa3e065b543ae'
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
