$packageName = 'sandboxie.install'
$packageSearch = 'sandboxie'
$installerType = 'exe'
$url = 'http://www.sandboxie.com/attic/SandboxieInstall32-512.exe'
$checksum = 'ced2b8952cb14947ca823a8c6e8d8961edebafe7'
$checksumType = 'sha1'
$url64 = 'http://www.sandboxie.com/attic/SandboxieInstall64-512.exe'
$checksum64 = 'd3b0e9dbda7a503103f5398e2b84694b24752d80'
$checksumType64 = 'sha1'
$validExitCodes = @(0)
$silentArgs = '/S'
$reg = Get-ItemProperty -Path @( 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' ) `
                           -ErrorAction:SilentlyContinue `
          | Where-Object   { $_.DisplayName -like "$packageSearch*" }
if ($reg) { 
  $silentArgs += ' /upgrade'
} else {
  $silentArgs += ' /install'
}

Install-ChocolateyPackage -PackageName "$packageName" `
                          -FileType "$installerType" `
                          -Url "$url" `
                          -Url64bit "$url64" `
                          -SilentArgs "$silentArgs" `
                          -ValidExitCodes $validExitCodes `
                          -Checksum "$checksum" `
                          -ChecksumType "$checksumType" `
                          -Checksum64 "$checksum64" `
                          -ChecksumType64 "$checksumType64"