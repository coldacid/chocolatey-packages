$packageName   = 'retroarch'
$url           = 'https://buildbot.libretro.com/stable/1.9.4/windows/x86/RetroArch.7z'
$url64         = 'https://buildbot.libretro.com/stable/1.9.4/windows/x86_64/RetroArch.7z'
$checksum      = '526131c667d56b52ab07f209c02f79094c02cd5cbd09dea73926c554b3ca8d21'
$checksum64    = '549372470f8ec7941cf2cbca2e8b1921a9d5f05c25f13775d03ccd1e206c1fc1'
$checksumType  = 'sha256'
$checksumType64= 'sha256'


# Get the package parameters and then back them up for the uninstaller
# This works around choco#1479 https://github.com/chocolatey/choco/issues/1479
$pp = Get-PackageParameters
$toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$paramsFile = Join-Path (Split-Path -Parent $toolsPath) 'PackageParameters.xml'
Write-Debug "Writing package parameters to $paramsFile"
Export-Clixml -Path $paramsFile -InputObject $pp

if ((Get-ProcessorBits 32) -or $env:ChocolateyForceX86 -eq 'true') {
  $specificFolder = "RetroArch-Win32"
} else {
  $specificFolder = "RetroArch-Win64"
}

$installDir = $(Get-ToolsLocation)
if ($pp.InstallDir -or $pp.InstallationPath ) { $installDir = $pp.InstallDir + $pp.InstallationPath }
Write-Host "RetroArch is going to be installed in '$installDir'"

Install-ChocolateyZipPackage "$packageName" `
  -Url "$url" -Checksum "$checksum" -ChecksumType $checksumType `
  -Url64 "$url64" -Checksum64 "$checksum64" -ChecksumType64 $checksumType64 `
  -UnzipLocation "$installDir" -SpecificFolder "$specificFolder"

if ($installDir -eq $toolsPath) {
  New-Item "$installDir\$specificFolder\retroarch.exe.gui" -Type file -Force | Out-Null
  if (Test-Path "$installDir\$specificFolder\retroarch_debug.exe") {
    New-Item "$installDir\$specificFolder\retroarch_debug.exe.gui" -Type file -Force | Out-Null
  }
} else {
  Install-BinFile retroarch -path "$installDir\$specificFolder\retroarch.exe" -UseStart
  if (Test-Path "$installDir\$specificFolder\retroarch_debug.exe") {
    Install-BinFile retroarch_debug -path "$installDir\$specificFolder\retroarch_debug.exe" -UseStart
  }
}

if ($pp.DesktopShortcut) {
  $desktop = [System.Environment]::GetFolderPath("Desktop")
  Install-ChocolateyShortcut -ShortcutFilePath "$desktop\RetroArch.lnk" `
    -TargetPath "$installDir\$specificFolder\retroarch.exe" -WorkingDirectory "$installDir" `
    -WindowStyle 3
}
