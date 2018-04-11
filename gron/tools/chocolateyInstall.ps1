$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'gron'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$zip32 = 'gron-windows-386-0.5.2.zip'
$zip64 = 'gron-windows-amd64-0.5.2.zip'

$packageArgs = @{
  packageName    = $packageName
  FileFullPath   = Join-Path $toolsDir $zip32
  FileFullPath64 = Join-Path $toolsDir $zip64
  Destination    = $toolsDir
}

Get-ChocolateyUnZip @packageArgs
