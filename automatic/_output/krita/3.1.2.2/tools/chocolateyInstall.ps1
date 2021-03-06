$packageName = 'krita'
$installerType = 'exe'
$silentArgs = '/S'
$url = 'http://download.kde.org/stable/krita/3.1.2/krita-3.1.2.2-x86-setup.exe'
$checksum = ''
$checksumType = 'sha256'
$url64 = 'http://download.kde.org/stable/krita/3.1.2/krita-3.1.2.1-x64-setup.exe'
$checksum64 = 'ee3c4a65e60cb2789dafc14ca8d62ab0399a3566197a8a92f89ec283fee6d57a'
$checksumType64 = 'sha256'
$validExitCodes = @(0)

Install-ChocolateyPackage -PackageName "$packageName" `
                          -FileType "$installerType" `
                          -SilentArgs "$silentArgs" `
                          -Url "$url" `
                          -Url64bit "$url64" `
                          -ValidExitCodes $validExitCodes `
                          -Checksum "$checksum" `
                          -ChecksumType "$checksumType" `
                          -Checksum64 "$checksum64" `
                          -ChecksumType64 "$checksumType64"