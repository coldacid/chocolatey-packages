$packageName = 'sandboxie.beta'
$packageId = 'sandboxie'
$installerType = 'EXE'
$url  = 'http://www.sandboxie.com/SandboxieInstall32-415-9.exe'
$url64 = 'http://www.sandboxie.com/SandboxieInstall64-415-9.exe'
$silentArgsInstall = '/install /S /D=C:\Program Files\Sandboxie'
$silentArgsUpgrade = '/upgrade /S'
$chocoRoot = $env:ChocolateyInstall
if ($chocoRoot -eq $null) {
$chocoRoot = "$env:programdata\chocolatey"
}
if (Test-Path $chocoRoot\lib\$packageName.install.*) { 
	Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgsUpgrade" "$url" "$url64"
} else {
	Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgsInstall" "$url" "$url64"
}
