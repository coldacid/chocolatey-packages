$packageName = 'speedfan'
$installerType = 'EXE'
#$url = 'http://www.almico.com/{anchor1}.exe'
$url = 'http://www.almico.com/speedfan449.exe'
$silentArgs = '/S'
$validExitCodes = @(0) #please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"  -validExitCodes $validExitCodes