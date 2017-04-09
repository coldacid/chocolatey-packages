function Get-VisualStudio() {
  $versions = vswhere.exe -legacy -format json | ConvertFrom-Json
  $versions = $versions | Where-Object { ($_.installationPath -ne $null) -and (Test-Path $(Join-Path $_.installationPath 'Common7\IDE\devenv.exe')) }
  $versions | ForEach-Object {
    $_.installationVersion = [System.Version]($_.installationVersion)
    $_
  }
}
