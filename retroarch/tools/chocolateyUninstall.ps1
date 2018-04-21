$packageName   = 'retroarch'
$zip32         = 'RetroArch.7z'
$zip64         = 'RetroArch.7z'

if (Get-ProcessorBits -eq 64) { $zip = $zip64 } else { $zip = $zip32 }
Uninstall-ChocolateyZipPackage "$packageName" "$zip"

$toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$pp = Get-PackageParameters
$installDir = $toolsPath
if ($pp.InstallDir -or $pp.InstallationPath ) { $installDir = $pp.InstallDir + $pp.InstallationPath }

#if ($installDir -ne $toolsPath) { # choco issue #1479
  Uninstall-BinFile retroarch -path "$installDir\retroarch.exe"
  Uninstall-BinFile retroarch_debug -path "$installDir\retroarch_debug.exe"
#}

#if ($pp.DesktopShortcut) { # choco issue #1479
  $desktop = [System.Environment]::GetFolderPath("Desktop")
  Remove-Item "$desktop\RetroArch.lnk" -ErrorAction SilentlyContinue -Force | Out-Null
#}
