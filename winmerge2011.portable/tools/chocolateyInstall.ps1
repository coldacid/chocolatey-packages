$packageName = 'winmerge2011.portable' # arbitrary name for the package, used in messages
$url = '{{DownloadUrl}}' # download url
$url64 = '{{DownloadUrlx64}}' # 64bit URL here or remove - if installer decides, then use $url
$checksum = '{{Checksum}}'
$checksum64 = '{{Checksumx64}}'

$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage "$packageName" `
  -Url "$url" -Checksum "$checksum" -ChecksumType sha256 `
  -Url64 "$url64" -Checksum64 "$checksum64" -ChecksumType64 sha256 `
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
