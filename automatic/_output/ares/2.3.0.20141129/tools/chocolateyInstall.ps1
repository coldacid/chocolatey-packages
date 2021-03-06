$packageName = 'ares'
$installerType = 'EXE'
$url = 'http://heanet.dl.sourceforge.net/project/aresgalaxy/aresgalaxy/AresRegular230_081714/aresregular230_installer.exe'
$silentArgs = '/S'
$validExitCodes = @(0) #please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx

try {

	Install-ChocolateyPackage $packageName $installerType $silentArgs $url -validExitCodes $validExitCodes
	
	Write-ChocolateySuccess $packageName
	
} catch {
	Write-ChocolateyFailure $packageName $($_.Exception.Message)
	throw 
}