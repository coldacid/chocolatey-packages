$packageName = 'firefox-nightly'
$softwareVersion = '61.0.1.2018040900-alpha' -Replace "^(\d+)\.(\d+)\.(\d+)[^-]+-([a-z]).*",'$1.$2$4$3'
$softwareName = "Nightly $softwareVersion*"
$installerType = 'exe'
$silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
$validExitCodes = @(0)

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

$key | ForEach-Object {
  Uninstall-ChocolateyPackage -PackageName $packageName `
                              -FileType $installerType `
                              -SilentArgs $($silentArgs) `
                              -File $($_.UninstallString.Replace('"','')) `
                              -ValidExitCodes $validExitCodes
}