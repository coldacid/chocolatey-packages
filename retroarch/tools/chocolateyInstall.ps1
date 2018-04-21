$packageName   = 'retroarch'
$url           = 'https://buildbot.libretro.com/stable/1.7.5/windows/x86/RetroArch.7z'
$url64         = 'https://buildbot.libretro.com/stable/1.7.5/windows/x86_64/RetroArch.7z'
$checksum      = 'b28e874524e1074d20fca4ecad2d8710fd52920edfc21109e61320437ac6fa79'
$checksum64    = 'aa71a32e6b6d05abfa095a931725c99d8301138206d2dd09fcf5bb1ca9fb5a32'
$checksumType  = 'sha256'
$checksumType64= 'sha256'

$toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$pp = Get-PackageParameters
$installDir = $toolsPath
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
