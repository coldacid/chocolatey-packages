#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$packageName = 'retroarch' # arbitrary name for the package, used in messages
$url = '{{DownloadUrl}}' # download url
$url64 ='{{DownloadUrlx64}}' # 64bit URL here or remove - if installer decides, then use $url
$checksum = '{{Checksum}}'
$checksum64 = '{{Checksumx64}}'

# if removing $url64, please remove from here
$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage "$packageName" `
  -Url "$url" -Checksum "$checksum" -ChecksumType sha256 `
  -Url64 "$url64" -Checksum64 "$checksum64" -ChecksumType64 sha256 `
  -UnzipLocation "$installDir"

New-Item "$installDir\retroarch.exe.gui" -Type file -Force | Out-Null
New-Item "$installDir\retroarch_debug.exe.gui" -Type file -Force | Out-Null
