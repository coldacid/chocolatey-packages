$packageName = 'ofview.portable'
$url = 'http://www.nirsoft.net/utils/ofview.zip'
$checksum = '{checksum}'
$checksumType = 'sha256'
$url64 = 'http://www.nirsoft.net/utils/ofview-x64.zip'
$checksum64 = '{checksumx64}'
$checksumType64 = 'sha256'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installFile = Join-Path $toolsDir "ofview.exe"

Install-ChocolateyZipPackage -PackageName "$packageName" `
                             -Url "$url" `
                             -UnzipLocation "$toolsDir" `
                             -Url64bit "$url64" `
                             -Checksum "$checksum" `
                             -ChecksumType "$checksumType" `
                             -Checksum64 "$checksum64" `
                             -ChecksumType64 "$checksumType64"

Set-Content -Path ("$installFile.gui") `
            -Value $null