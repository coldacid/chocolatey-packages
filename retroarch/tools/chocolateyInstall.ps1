#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$packageName   = 'retroarch' # arbitrary name for the package, used in messages
$url           = 'https://buildbot.libretro.com/stable/1.7.5/windows/x86/RetroArch.7z' # download url
$url64         = 'https://buildbot.libretro.com/stable/1.7.5/windows/x86_64/RetroArch.7z' # 64bit URL here or remove - if installer decides, then use $url
$checksum      = 'b28e874524e1074d20fca4ecad2d8710fd52920edfc21109e61320437ac6fa79'
$checksum64    = 'aa71a32e6b6d05abfa095a931725c99d8301138206d2dd09fcf5bb1ca9fb5a32'
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
