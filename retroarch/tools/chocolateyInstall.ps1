#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$packageName   = 'retroarch' # arbitrary name for the package, used in messages
$url           = 'https://buildbot.libretro.com/stable/1.7.1/windows/x86/RetroArch.7z' # download url
$url64         = 'https://buildbot.libretro.com/stable/1.7.1/windows/x86_64/RetroArch.7z' # 64bit URL here or remove - if installer decides, then use $url
$checksum      = 'ca48b1a09dc74c5a8074011d07585d48c20965ede5d5aac6e75f2ecd11451931'
$checksum64    = 'ed199ec8093f0b66bd52c512518e7d7dd80e17fb5384c7f5ebe8795192edd605'
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
