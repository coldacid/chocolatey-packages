$packageName   = 'biblioteq' # arbitrary name for the package, used in messages
$url           = 'https://github.com/textbrowser/biblioteq/releases/download/2021.10.30/BiblioteQ.zip' # download url
$checksum      = '284bc9b6b68766ced372be3a5dd556db20b0f5d8514899bbd7c1f7f59277feed'
$checksumType  = 'sha256'

$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage "$packageName" `
  -Url "$url" -Checksum "$checksum" -ChecksumType "$checksumType" `
  -UnzipLocation "$installDir"

$mainExe = ''

# generate ignore and gui for executables
Get-ChildItem -Path $installDir -Filter "*.exe" -Recurse | ForEach-Object {
  $exe = $_.FullName
  if ($_.BaseName.ToLowerInvariant() -eq 'biblioteq') {
    New-Item "${exe}.gui" -Type file -Force | Out-Null
    $mainExe = $exe
  } else {
    New-Item "${exe}.ignore" -Type file -Force | Out-Null
  }
}

$wd = Split-Path $mainExe -parent
$programs = [System.Environment]::GetFolderPath("Programs")
Install-ChocolateyShortcut -ShortcutFilePath "$programs\BiblioteQ.lnk" `
  -TargetPath "$mainExe" -WorkingDirectory "$wd"
