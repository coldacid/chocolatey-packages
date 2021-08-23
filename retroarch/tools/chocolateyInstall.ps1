$packageName   = 'retroarch'
$url           = 'https://buildbot.libretro.com/stable/1.9.8/windows/x86/RetroArch.7z'
$url64         = 'https://buildbot.libretro.com/stable/1.9.8/windows/x86_64/RetroArch.7z'
$checksum      = 'a4e7bd4922c256be7cbdd63fc41ded9ea2d558efd6b5737be1a1bec602221545'
$checksum64    = 'ec6e22289b5d3b34678d31efd2452a2774b3919de17ff790e12ec0c934f9561a'
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
