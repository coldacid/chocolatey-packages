$packageName = 'ddu'
$installerType = 'EXE'
$url = 'http://download.instalki.info/programy/Windows/Narzedzia/zarzadzanie_sterownikami/DDU.v13.1.0.0_www.INSTALKI.pl.exe'
$silentArgs = ''
$validExitCodes = @(0) #please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"  -validExitCodes $validExitCodes