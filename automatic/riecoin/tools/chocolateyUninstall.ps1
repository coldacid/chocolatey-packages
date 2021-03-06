$packageName = '{{PackageName}}'
$fileType = 'exe'
$silentArgs = '/S'
$validExitCodes = @(0)
$unPath = "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
$unString=(Get-ItemProperty "$unpath\$packageName*" UninstallString).UninstallString)

Uninstall-ChocolateyPackage "$packageName" "$fileType" "$silentArgs" "$unString" -validExitCodes $validExitCodes

