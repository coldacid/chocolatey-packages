$packageName = 'combofix'
$url = 'https://download.bleepingcomputer.com/sUBs/ComboFix.exe'
$checksum = 'eacb568e678e27c477e0bf80946a19840d0df48d6206c5c46cc96cc693db4805'
$checksumType = 'sha256'
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$installFile = Join-Path $toolsDir "ComboFix.exe"

Get-ChocolateyWebFile -PackageName "$packageName" `
                      -FileFullPath "$installFile" `
                      -Url "$url" `
                      -Checksum "$checksum" `
                      -ChecksumType "$checksumType"

Write-Verbose "Create an empty sidecar metadata file for shimgen.exe to designate executable as GUI."
Set-Content -Path ("$installFile.gui") `
            -Value $null