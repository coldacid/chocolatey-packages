$packageName = 'ddu'
$url = 'http://www.wagnardmobile.com/DDU/download/DDU%20v17.0.5.2.exe'
$checksum = '1fa3720c5fb2321ede2b74a7e4629fc9db2c55aec5b3de3caf349572eb47d838'
$checksumType = 'sha256'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installFile = Join-Path $toolsDir "Display Driver Uninstaller.exe"

# 0.9.7: custom headers not supported in 1st tier api helper functions
# thusly, require more setup to use deeper, 2nd tier helper functions
# 0.9.10: revisit: https://github.com/chocolatey/choco/issues/332
$chocTempDir = Join-Path $Env:Temp "chocolatey"
$tempDir = Join-Path $chocTempDir "$packageName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$zipFile = Join-Path $tempDir "$($packageName)Install.zip"
$referer = 'http://www.wagnardmobile.com/forums/viewtopic.php?f=5'
$wc = New-Object System.Net.WebClient
$wc.Headers.Add("Referer", $referer)
$wc.DownloadFile($url, $zipFile)

Get-ChecksumValid -File "$zipFile" `
                  -Checksum "$checksum" `
                  -ChecksumType "$checksumType"
                  
Get-ChocolateyUnzip -FileFullPath "$zipFile" `
                    -Destination "$toolsDir" `
                    -PackageName "$packageName"

# create sidecar file for shimgen
Set-Content -Path ("$installFile.gui") `
            -Value $null
