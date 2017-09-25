$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'ldapadmin'
$version    = '{{PackageVersion}}'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = '{{DownloadUrl}}'
$url64      = '{{DownloadUrlx64}}'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir

  url           = $url
  url64bit      = $url64

  checksum      = '{{Checksum}}'
  checksumType  = 'sha256'
  checksum64    = '{{Checksumx64}}'
  checksumType64= 'sha256'

  options       = @{
    Headers     = @{
      'User-Agent' = 'Wget/1.19.1'
    }
  }
}

Install-ChocolateyZipPackage @packageArgs

New-Item (Join-Path $toolsDir "LdapAdmin.exe.gui") -Type file -Force | Out-Null
