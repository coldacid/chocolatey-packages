$packageName   = 'winmerge2011.portable' # arbitrary name for the package, used in messages
$url           = 'https://bitbucket.com/jtuc/winmerge2011/downloads/WinMerge_0.2011.007.444_change_7z_to_exe_if_you_want_a_setup.7z' # download url
$url64         = 'https://bitbucket.com/jtuc/winmerge2011/downloads/WinMerge_0.2011.007.444_x64_change_7z_to_exe_if_you_want_a_setup.7z' # 64bit URL here or remove - if installer decides, then use $url
$checksum      = '267a53dce1c08f7a90b8f2222a5400e7aaa15fc789383d2cedc624cd5f3de18f'
$checksum64    = '4eb072d660bb8a0eccf2737dc012a5b949c6653bff1a1c71eadc1ee3c6f19948'
$checksumType  = 'sha256'
$checksumType64= 'sha256'

$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage "$packageName" `
  -Url "$url" -Checksum "$checksum" -ChecksumType "$checksumType" `
  -Url64 "$url64" -Checksum64 "$checksum64" -ChecksumType64 "$checksumType64" `
  -UnzipLocation "$installDir"

# generate ignore and gui for executables
Get-ChildItem -Path $installDir -Filter "*.exe" -Recurse | ForEach-Object {
  $exe = $_.FullName
  if ($_.BaseName -eq 'winmergeu') {
    New-Item "${exe}.gui" -Type file -Force | Out-Null
  } else {
    New-Item "${exe}.ignore" -Type file -Force | Out-Null
  }
}
