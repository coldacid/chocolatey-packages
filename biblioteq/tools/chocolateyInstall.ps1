$packageName   = 'biblioteq' # arbitrary name for the package, used in messages
$url           = 'https://github.com/textbrowser/biblioteq/releases/download/2021.06.12/BiblioteQ.zip' # download url
$checksum      = '08395948c7bd534bcdb83028db85393ed99aad616fd0759f803d4f7b516b8b27'
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
