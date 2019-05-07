$packageName   = 'retroarch'
$url           = 'https://buildbot.libretro.com/stable/1.7.7/windows/x86/RetroArch.7z'
$url64         = 'https://buildbot.libretro.com/stable/1.7.7/windows/x86_64/RetroArch.7z'
$checksum      = '9e661b70e9435a1b00df5f203c60808640bd24cfa0600190d1931aebb8d106cf'
$checksum64    = 'cf5e4467277852c34c9253006eb2df67aa612f0f17683a73f71669f6029cfa7a'
$checksumType  = 'sha256'
$checksumType64= 'sha256'


# Get the package parameters and then back them up for the uninstaller
# This works around choco#1479 https://github.com/chocolatey/choco/issues/1479
$pp = Get-PackageParameters
$toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$paramsFile = Join-Path (Split-Path -Parent $toolsPath) 'PackageParameters.xml'
Write-Debug "Writing package parameters to $paramsFile"
Export-Clixml -Path $paramsFile -InputObject $pp

$installDir = Join-Path $(Get-ToolsLocation) $packageName
if ($pp.InstallDir -or $pp.InstallationPath ) { $installDir = $pp.InstallDir + $pp.InstallationPath }
Write-Host "RetroArch is going to be installed in '$installDir'"

Install-ChocolateyZipPackage "$packageName" `
  -Url "$url" -Checksum "$checksum" -ChecksumType $checksumType `
  -Url64 "$url64" -Checksum64 "$checksum64" -ChecksumType64 $checksumType64 `
  -UnzipLocation "$installDir"

if ($installDir -eq $toolsPath) {
  New-Item "$installDir\retroarch.exe.gui" -Type file -Force | Out-Null
  New-Item "$installDir\retroarch_debug.exe.gui" -Type file -Force | Out-Null
} else {
  Install-BinFile retroarch -path "$installDir\retroarch.exe" -UseStart
  Install-BinFile retroarch_debug -path "$installDir\retroarch_debug.exe" -UseStart
}

if ($pp.DesktopShortcut) {
  $desktop = [System.Environment]::GetFolderPath("Desktop")
  Install-ChocolateyShortcut -ShortcutFilePath "$desktop\RetroArch.lnk" `
    -TargetPath "$installDir\retroarch.exe" -WorkingDirectory "$installDir" `
    -WindowStyle 3
}
