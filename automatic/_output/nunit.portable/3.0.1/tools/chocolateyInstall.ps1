$packageName = 'nunit.portable'
$url = 'https://github.com/nunit/nunit/releases/download/3.0.1/NUnit-3.0.1.zip'
$checksum = '7cd9751f8dce1d8bfeba308b6802d169'
$checksumType = 'md5'
$url64 = "$url"
$checksum64 = "$checksum"
$checksumType64 = "$checksumType"
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Install-ChocolateyZipPackage -PackageName "$packageName" `
                             -Url "$url" `
                             -UnzipLocation "$toolsDir" `
                             -Url64bit "$url64" `
                             -Checksum "$checksum" `
                             -ChecksumType "$checksumType" `
                             -Checksum64 "$checksum64" `
                             -ChecksumType64 "$checksumType64"