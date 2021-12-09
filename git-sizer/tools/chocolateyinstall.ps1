$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'git-sizer'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$zip32 = 'git-sizer-1.5.0-windows-386.zip'
$zip64 = 'git-sizer-1.5.0-windows-amd64.zip'

$packageArgs = @{
  packageName    = $packageName
  FileFullPath   = Join-Path $toolsDir $zip32
  FileFullPath64 = Join-Path $toolsDir $zip64
  Destination    = $toolsDir
}

Get-ChocolateyUnZip @packageArgs
