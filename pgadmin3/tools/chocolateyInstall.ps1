$packageName    = 'pgadmin3'
$installerType  = 'msi'
$silentArgs     = "/quiet"
$validExitCodes = @(0) #please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx

$version = "{{PackageVersion}}"

$zip_file = "pgadmin3-${version}.zip"
$zip_url  = "{{DownloadUrl}}"
$msi_file = "pgadmin3.msi"
$checksum = "{{Checksum}}"


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

# FILE: helpers\functions\Get-ChocolateyUnzip.ps1
#       $7zip = Join-Path "$env:ChocolateyInstall" 'chocolateyinstall\tools\7za.exe'
if ("x$env:ChocolateyInstall" -eq "x") {
  Write-ChocolateyFailure "$packageName" "The ChocolateyInstall Environment variable is NOT SET!, Get-ChocolateyUnzip requires the ChocolateyInstall environment variable and this installation can NOT continue without it. Set ChocolateyInstall=C:\Chocolatey"
  }

if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}

try {
  Write-Host ""
  Write-Host "Downloading $packageName"
  Write-Host "  * Zip File Temp: $zip_file_temp"
  Write-Host "  * Zip URL......: $zip_url"
  Write-Host ""
# Get-ChocolateyWebFile $packageName   $fileFullPath  $url     $url64bit
#                       -checksum $checksum -checksumType $checksumType
#                       -checksum64 $checksum64 -checksumType64 $checksumType64
  Get-ChocolateyWebFile "$packageName" $zip_file_temp $zip_url $zip_url `
                        -checksum $checksum -checksumType sha256 `
                        -checksum64 $checksum -checksumType64 sha256
} catch {
  Write-ChocolateyFailure "$packageName" "Could not download zip file to $zip_file_temp. REASON: $($_.Exception.Message)"
  throw
}


try {
# Get-ChocolateyUnzip $fileFullPath $destination
  Write-Host ""
  Write-Host "Unzipping file"
  Write-Host "  * FROM: $zip_file_temp"
  Write-Host "  * TO..: $tempDir"
  Write-Host ""
  Get-ChocolateyUnzip "$zip_file_temp" "$tempDir"
  # param(
  # [string] $fileFullPath..: This is the full path to your zip file.
  # [string] $destination...: This is a directory where you would like the unzipped files to end up.
  # [string] $specificFolder: OPTIONAL - This is a specific directory within zip file to extract.
  # [string] $packageName...: OPTIONAL - This will faciliate logging unzip activity for subsequent uninstall
  #$scriptPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
  #Get-ChocolateyUnzip "c:\someFile.zip" $scriptPath somedirinzip\somedirinzip
  #Get-ChocolateyUnzip "C:\Chocolatey\pgadmin3\pgadmin3-1.18.1.zip" "C:\Chocolatey\pgadmin3.extracted"
} catch {
  Write-ChocolateyFailure "$packageName" "Could not unzip zip file. REASON: $($_.Exception.Message)"
  throw
}

try {
  Install-ChocolateyPackage "$packageName" "$installerType" $silentArgs $msi_file_temp -validExitCodes $validExitCodes
} catch {
  Write-ChocolateyFailure "$packageName" "Could not install msi. REASON: $($_.Exception.Message)"
  throw
}

  Write-ChocolateySuccess "$packageName"

