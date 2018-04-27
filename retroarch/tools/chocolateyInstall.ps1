#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$packageName   = 'retroarch' # arbitrary name for the package, used in messages
$url           = 'https://buildbot.libretro.com/stable/1.7.2/windows/x86/RetroArch.7z' # download url
$url64         = 'https://buildbot.libretro.com/stable/1.7.2/windows/x86_64/RetroArch.7z' # 64bit URL here or remove - if installer decides, then use $url
$checksum      = '98d68e307242a696cad4179afb971b765e9d1d10c0bde88409612d2da4961b4c'
$checksum64    = 'e1e31cb0b03e1fa8e094bd06d0178ee7177bf02bf3b8caee70eb5d10c9e6e5f9'
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
