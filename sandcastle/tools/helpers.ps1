function Get-VisualStudio {
  $versions = vswhere.exe -legacy -format json | ConvertFrom-Json
  $versions = $versions | Where-Object { ($_.installationPath -ne $null) -and (Test-Path $(Join-Path $_.installationPath 'Common7\IDE\devenv.exe')) }
  $versions | ForEach-Object {
    $_.installationVersion = [System.Version]($_.installationVersion)
    $_
  }
}

function Install-VsixEXT {
param(
  [parameter(Mandatory=$true, Position=0)] $installer,
  [parameter(Mandatory=$true, Position=1)] $installFile,
  [parameter(Mandatory=$true, Position=2)] $version = '15.0',
  [parameter(Mandatory=$true, Position=3)] $sku = 'Community',
  [parameter(ValueFromRemainingArguments = $true)][Object[]] $ignoredArguments
)

  # use original function for pre-2017
  if (([System.Version]$version).Major -lt 15) {
    return Install-Vsix "$installer" "$installFile"
  }

  Write-FunctionCallLogMessage -Invocation $MyInvocation -Parameters $PSBoundParameters

  if ($env:chocolateyPackageName -ne $null -and $env:chocolateyPackageName -eq $env:ChocolateyInstallDirectoryPackage) {
    Write-Warning "Install Directory override not available for VSIX packages."
  }

  Write-Host "Installing $installFile using $installer for Visual Studio $sku $version"
  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName = $installer
  $psi.Arguments = "/q /v:$version /s:$sku $installFile"
  $s = [System.Diagnostics.Process]::Start($psi)
  $s.WaitForExit()

  return $s.ExitCode
}
