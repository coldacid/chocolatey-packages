$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName   = 'winvice'
$version       = '3.1'
$toolsDir      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url           = 'https://downloads.sourceforge.net/project/vice-emu/releases/binaries/windows/WinVICE-3.1-x86.7z'
$url64         = 'https://downloads.sourceforge.net/project/vice-emu/releases/binaries/windows/WinVICE-3.1-x64.7z'
$checksum      = 'ae4fc6677b301bd37eaba86b671775e64837298637af5238a648fb7e8180aaa8'
$checksum64    = '6cc96f182aa5d1cb9ec2755e2547d301f9746b3b9b38f123dfc692732579d941'
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
