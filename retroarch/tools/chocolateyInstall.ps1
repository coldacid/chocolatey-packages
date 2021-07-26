$packageName   = 'retroarch'
$url           = 'https://buildbot.libretro.com/stable/1.9.7/windows/x86/RetroArch.7z'
$url64         = 'https://buildbot.libretro.com/stable/1.9.7/windows/x86_64/RetroArch.7z'
$checksum      = 'b1d4313b5bc72e33266f13a8f43cd21588b8de34046a1c7c701d61c6fb9e15aa'
$checksum64    = '9890a8fdf3e1fe79f782ebc33bb203af371a9fe24950859acba83d476a7860a2'
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
