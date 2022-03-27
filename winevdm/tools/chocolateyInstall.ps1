$ErrorActionPreference = 'Stop'; # stop on all errors

if (!(Test-ProcessAdminRights)) {
  throw "Administrative rights are required to install this package."
}

$packageName= 'winevdm'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$zip        = 'otvdm-v0.8.1.zip'

$packageArgs = @{
  packageName    = $packageName
  FileFullPath   = Join-Path $toolsDir $zip
  Destination    = $toolsDir
}

Get-ChocolateyUnZip @packageArgs

$otvdm = "otvdm.exe"

# Prevent stubbing of emulated Windows executables
# Also nab the full path for otvdm.exe
$exes = Get-ChildItem $toolsDir -Include *.exe -Recurse
foreach ($exe in $exes) {
  $fileName = Split-Path $exe -Leaf
  if ($fileName -eq $otvdm) {
    $otvdm = $exe
    continue
  }
  if ( ($fileName -eq "otvdmw.exe") -or ($fileName -eq "winhlp32.exe") ) {
    New-Item "$exe.gui" -Type File -Force | Out-Null

    if ($fileName -eq "winhelp32.exe") {
      Install-ChocolateyFileAssociation -Extension '.hlp' -Executable $exe
    }

    continue
  }
  New-Item "$exe.ignore" -Type File -Force | Out-Null
}
# Tell ShimGen to ignore .exe16 files as well
$exe16s = Get-ChildItem $toolsDir -Include *.exe16 -Recurse
foreach ($exe16 in $exe16s) {
  New-Item "$exe16.ignore" -Type File -Force | Out-Null
}

function New-Vdm {
  param (
    $RegistryKey,
    $ExePath
  )

  if (!(Test-Path $RegistryKey)) {
    New-Item -Path $RegistryKey -Force
  }

  Set-ItemProperty -Path $RegistryKey -Name CommandLine -Value ' --ntvdm64: "%m" --ntvdm64-args: %c'
  Set-ItemProperty -Path $RegistryKey -Name InternalName -Value '*'
  Set-ItemProperty -Path $RegistryKey -Name ProductName -Value '*'
  Set-ItemProperty -Path $RegistryKey -Name ProductVersion -Value '*'
  Set-ItemProperty -Path $RegistryKey -Name MappedExeName -Value $ExePath
}

New-Vdm -RegistryKey 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NtVdm64\0OTVDM' -ExePath $otvdm
if (Get-OSArchitectureWidth -Compare 64) {
  New-Vdm -RegistryKey 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\NtVdm64\0OTVDM' -ExePath $otvdm
}
