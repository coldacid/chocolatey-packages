$packageName    = 'pgadmin3'
$installerType  = 'msi'
$silentArgs     = "/quiet"
$validExitCodes = @(0) #please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx

$zip_file     = 'pgadmin3-1.22.2.zip'
$zip_url      = 'https://ftp.postgresql.org/pub/pgadmin/pgadmin3/v1.22.2/win32/pgadmin3-1.22.2.zip'
$msi_file     = 'pgadmin3.msi'
$checksum     = 'dead649ddac52518d01976dffc0d85dd626f874c7b1c542eb5c817a2a6cd634d'
$checksumType = 'sha256'


$chocTempDir   = Join-Path $env:TEMP "chocolatey"
$tempDir       = Join-Path $chocTempDir "$packageName"
$msi_file_temp = Join-Path $tempDir $msi_file
$zip_file_temp = Join-Path $tempDir $zip_file

Write-Host "pgAdmin3 Installer:"
Write-Host "  * Package...........: $packageName"
Write-Host "  * Choco Temp........: $chocoTempDir"
Write-Host "  * Temp Dir..........: $tempDir"
Write-Host "  * MSI Temp..........: $msi_file_temp"
Write-Host "  * Zip Temp..........: $zip_file_temp"
Write-Host "  * Zip File..........: $zip_file"
Write-Host "  * Zip URL...........: $zip_url"
Write-Host "  * MSI File..........: $msi_file"
Write-Host "  * ChocolateyInstall.: $env:ChocolateyInstall"
Write-Host ""

if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}

Write-Host ""
Write-Host "Downloading $packageName"
Write-Host "  * Zip File Temp: $zip_file_temp"
Write-Host "  * Zip URL......: $zip_url"
Write-Host ""
# No special 64-bit builds available
Get-ChocolateyWebFile "$packageName" $zip_file_temp $zip_url `
                      -checksum $checksum -checksumType $checksumType


Write-Host ""
Write-Host "Unzipping file"
Write-Host "  * FROM: $zip_file_temp"
Write-Host "  * TO..: $tempDir"
Write-Host ""
Get-ChocolateyUnzip "$zip_file_temp" "$tempDir"

Install-ChocolateyPackage "$packageName" "$installerType" $silentArgs $msi_file_temp -validExitCodes $validExitCodes
