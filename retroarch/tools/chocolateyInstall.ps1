#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$packageName   = 'retroarch' # arbitrary name for the package, used in messages
$url           = 'https://buildbot.libretro.com/stable/1.7.3/windows/x86/RetroArch.7z' # download url
$url64         = 'https://buildbot.libretro.com/stable/1.7.3/windows/x86_64/RetroArch.7z' # 64bit URL here or remove - if installer decides, then use $url
$checksum      = 'c7f96edd20ae369da8caed8ee7761cdd7ff0638c08196bfa33583deff668bf7b'
$checksum64    = 'a945e336b7699e1f4ef854b8ca852e8fb772d39b3d4387b4a9c616040b6b7bf4'
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
