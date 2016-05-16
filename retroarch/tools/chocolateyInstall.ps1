#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$packageName = 'retroarch' # arbitrary name for the package, used in messages
$url = '{{DownloadUrl}}' # download url
$url64 = $url.Replace('/x86/', '/x86_64/') # 64bit URL here or remove - if installer decides, then use $url

# if removing $url64, please remove from here
$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage "$packageName" "$url" "$installDir" "$url64"

New-Item "$installDir\retroarch.exe.gui" -Type file -Force | Out-Null
New-Item "$installDir\retroarch_debug.exe.gui" -Type file -Force | Out-Null
