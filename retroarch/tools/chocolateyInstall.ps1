$packageName   = 'retroarch'
$url           = 'https://buildbot.libretro.com/stable/1.7.8/windows/x86/RetroArch.7z'
$url64         = 'https://buildbot.libretro.com/stable/1.7.8/windows/x86_64/RetroArch.7z'
$checksum      = 'd982a5e99a9b577c645e4ec57f1337184d238b018146e261361c02ee8c942592'
$checksum64    = 'ee0e7b2c0fa6795a68b9e763c2c34ffa33d6dbcffc820fc9fbaa608b3f629006'
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
