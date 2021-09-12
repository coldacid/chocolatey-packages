$packageName   = 'biblioteq' # arbitrary name for the package, used in messages
$url           = 'https://github.com/textbrowser/biblioteq/releases/download/2021.09.10/BiblioteQ.zip' # download url
$checksum      = 'ec325f151341050b0fa41caa94c3554ce5c01e666042c9b8e2d80cdaebce95af'
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
