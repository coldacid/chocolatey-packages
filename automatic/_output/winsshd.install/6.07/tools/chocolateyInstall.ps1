$packageName = 'Bitvise SSH Server'
$installerType = 'EXE'
$url  = 'http://dl.bitvise.com/BvSshServer-Inst.exe'
$silentArgs = '-acceptEULA -startService -startBssCtrl'
$validExitCodes = @(0,16)
Write-Verbose "You may pass native install arguments directly to Chocolatey with -ia -installArgs or -installArguments"
Write-Verbose "			For example: cinst -installArgs '-installDir=''C:\foo bar\'' winsshd"
Write-Verbose "			Note: Use two single quotes when double quotes are desired."
Write-Verbose "BvSshServer-Inst -installDir=directory OR -defaultSite OR -site=site-name"
Write-Verbose "                  [-force OR -abortOnWarning[=warning-list-or-mask]"
Write-Verbose "                  [-acceptEULA] [-interactive] [-noRollback]"
Write-Verbose "                  [-activationCode=activation-code-hex]"
Write-Verbose "                  [-keypairs=keypairs-file]"
Write-Verbose "                  [-settings=settings-file]"
Write-Verbose "                  [-siteTypeSettings=fileName]"
Write-Verbose "                  [-startService]"
Write-Verbose "                  [-startBssCtrl]"
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes