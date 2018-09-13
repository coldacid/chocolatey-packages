#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$packageName   = 'retroarch' # arbitrary name for the package, used in messages
$url           = 'https://buildbot.libretro.com/stable/1.7.4/windows/x86/RetroArch.7z' # download url
$url64         = 'https://buildbot.libretro.com/stable/1.7.4/windows/x86_64/RetroArch.7z' # 64bit URL here or remove - if installer decides, then use $url
$checksum      = '7595a34f0bba5c2c3e4f9154e99839d4817a1b754e09f098d46eaeaeff226415'
$checksum64    = 'e1817661a14443c075e6e333b8a9b6e9a018dfd77b7ec84e0fd386f19a142a2f'
$checksumType  = 'sha256'
$checksumType64= 'sha256'

# if removing $url64, please remove from here
$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Install-ChocolateyZipPackage "$packageName" `
  -Url "$url" -Checksum "$checksum" -ChecksumType $checksumType `
  -Url64 "$url64" -Checksum64 "$checksum64" -ChecksumType64 $checksumType64 `
  -UnzipLocation "$installDir"

New-Item "$installDir\retroarch.exe.gui" -Type file -Force | Out-Null
New-Item "$installDir\retroarch_debug.exe.gui" -Type file -Force | Out-Null
