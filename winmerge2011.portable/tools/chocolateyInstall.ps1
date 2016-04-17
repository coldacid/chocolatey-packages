$packageName = 'winmerge2011.portable' # arbitrary name for the package, used in messages
$url = '{{DownloadUrl}}' # download url
$url64 = '{{DownloadUrlx64}}' # 64bit URL here or remove - if installer decides, then use $url

try {
  $installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Install-ChocolateyZipPackage "$packageName" "$url" "$installDir" "$url64"

  # generate ignore and gui for executables
  New-Item "$installDir\WinMergeU.exe.gui" -Type file -Force | Out-Null
  New-Item "$installDir\tidy.exe.ignore" -Type file -Force | Out-Null

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
