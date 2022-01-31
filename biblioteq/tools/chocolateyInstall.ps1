$packageName   = 'biblioteq' # arbitrary name for the package, used in messages
$url           = 'https://github.com/textbrowser/biblioteq/releases/download/2022.01.30/BiblioteQ.zip' # download url
$checksum      = 'db98841210edd0da87977bc7e870f008758226b76093818b6863aa3186f09dfe'
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
