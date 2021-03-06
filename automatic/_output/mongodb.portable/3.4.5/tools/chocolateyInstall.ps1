# powershell v2 compatibility
$psVer = $PSVersionTable.PSVersion.Major
if ($psver -ge 3) {
  function Get-ChildItemDir {Get-ChildItem -Directory $args}
} else {
  function Get-ChildItemDir {Get-ChildItem $args}
}

$packageName = 'mongodb.portable'
$version = '3.4.5'
$url = 'https://downloads.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-3.4.5.zip'
$checksum = '8a9c1599ae8bf37a10126a7a163139ceb4fc6bf6468afdd14d0dddfe48b20909'
$checksumType = 'sha256'
$fileName = "mongodb-win32-x86_64-2008plus-ssl-$version"

Write-Verbose "Default install location is `'$env:ChocolateyToolsLocation`'"
$binRoot = Get-ToolsLocation

Write-Verbose "Allow overriding install location with package parameters."
function Parse-Parameters($arguments) {
  $packageParameters = $env:chocolateyPackageParameters
  Write-Host "Package parameters: $packageParameters"

  if ($packageParameters) {
    $match_pattern = "(?:\s*)(?<=[-|/])(?<name>\w*)[:|=]('((?<value>.*?)(?<!\\)')|(?<value>[\w]*))"

    if ($packageParameters -match $match_pattern ) {
      $results = $packageParameters | Select-String $match_pattern -AllMatches
      $results.matches | % {
        $key = $_.Groups["name"].Value.Trim();
        $value = $_.Groups["value"].Value.Trim();

        Write-Host "$key : $value";

        if ($arguments.ContainsKey($key)) {
            $arguments[$key] = $value;
        }
      }
    }
  }
}

Write-Debug "Process package parameters."
$arguments = @{}
$arguments["installDir"] = ""
Parse-Parameters $arguments
if ($arguments["installDir"]) {
  $binRoot = $arguments["installDir"]
}

Write-Debug "Installing to `'$binRoot`'"
$mongoPath = Join-Path $binRoot $packageName
$mongoBin = Join-Path $mongoPath 'bin'

$mongoDaemon = Join-Path $mongoBin 'mongod.exe'
if (Test-Path $mongoDaemon){
  Start-ChocolateyProcessAsAdmin "& $mongoDaemon --remove"
  if (Test-Path $mongoPath) {Remove-Item $mongoPath -Recurse -Force}
}

Install-ChocolateyZipPackage -PackageName "$packageName" `
                             -Url "$url" `
                             -UnzipLocation "$binRoot" `
                             -Checksum "$checksum" `
                             -ChecksumType "$checksumType"

$extractPath = Join-Path $binRoot $fileName                             
Rename-Item -Path $extractPath `
            -NewName $packageName `
            -Force

Install-ChocolateyPath $mongoBin 'Machine'

# setup mongo working dirs
$dataDir = Join-Path $mongoPath 'data'
if (!$(Test-Path $dataDir)) {mkdir $dataDir}
$logDir = Join-Path $mongoPath 'log'
if (!$(Test-Path $logDir)){mkdir $logDir}

# create batch files
$exeFile = Join-Path $mongoBin 'mongo.exe'
$batchFile = Join-Path $mongoBin 'mongo.bat'
"@echo off
$exeFile %*" | Out-File $batchFile -encoding ASCII
$batchFile = Join-Path $mongoBin 'mongorotatelogs.bat'
"@echo off
$exeFile --eval `'db.runCommand(`"logRotate`")`' mongohost:27017/admin" | Out-File $batchFile -encoding ASCII

# start mongodb as a Windows service
$logFile = Join-Path $logDir "MongoDB.log"
$installArgs = "$mongoDaemon --quiet --bind_ip 127.0.0.1 --logpath $logFile --logappend --dbpath $dataDir --directoryperdb --install; net start `"MongoDB`""
Start-ChocolateyProcessAsAdmin -Statements "$installArgs"