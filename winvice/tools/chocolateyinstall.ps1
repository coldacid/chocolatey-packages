$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'winvice'
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

$osBitness = Get-ProcessorBits
if ($osBitness -eq 32) {
  $platform = 'x86'
} else {
  $platform = 'x64'
}
$viceDir = Join-Path $toolsDir $([System.String]::Join('-', $packageName, $version, $platform))

Get-ChildItem -Path $viceDir -Filter "*.exe" | ForEach-Object {
  $prog = $_.BaseName; $exe = $_.FullName
  if ($prog -eq 'unzip') {
    New-Item "${exe}.ignore" -Type file -Force | Out-Null
  } elseif ($prog -like 'x*') {
    New-Item "${exe}.gui" -Type file -Force | Out-Null
  }
}
