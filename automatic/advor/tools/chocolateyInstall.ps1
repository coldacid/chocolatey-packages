$packageName = '{{PackageName}}'
$url = '{{DownloadUrlx64}}'
$checksum = '{{Checksum}}'
$checksumType = 'sha256'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installDir = Join-Path $toolsDir "AdvOR"
$installFile = Join-Path $installDir "AdvOR.exe"

Install-ChocolateyZipPackage -PackageName "$packageName" `
                             -Url "$url" `
                             -UnzipLocation "$toolsDir" `
                             -Checksum "$checksum" `
                             -ChecksumType "$checksumType"

Set-Content -Path ("$installFile.gui") `
            -Value $null
