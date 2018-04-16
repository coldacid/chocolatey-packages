$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName   = 'ldapadmin'
$version       = '1.8.3'
$toolsDir      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url           = 'https://downloads.sourceforge.net/project/ldapadmin/ldapadmin/1.8.3/LdapAdminExe-w32-1.8.3.zip'
$url64         = 'https://downloads.sourceforge.net/project/ldapadmin/ldapadmin/1.8.3/LdapAdminExe-w64-1.8.3.zip'
$checksum      = '20343e6b2f85e51ffb9ceeb88804cf1e24da1b1055a48a4ad0ecd170bdda7bdc'
$checksum64    = 'e2e9a3603150d14e2f7ae2cd85878ce187d953ff8fa01fcaa5b73949e573a4de'
$checksumType  = 'sha256'
$checksumType64= 'sha256'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir

  url           = $url
  url64bit      = $url64

  checksum      = $checksum
  checksumType  = $checksumType
  checksum64    = $checksum64
  checksumType64= $checksumType64

  options       = @{
    Headers     = @{
      'User-Agent' = 'Wget/1.19.1'
    }
  }
}

Install-ChocolateyZipPackage @packageArgs

New-Item (Join-Path $toolsDir "LdapAdmin.exe.gui") -Type file -Force | Out-Null
