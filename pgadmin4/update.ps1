Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = 'https://www.pgadmin.org/download/pgadmin-4-windows/'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyinstall.ps1" = @{
      "(?i)(^\s*[$]packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
      "(?i)(^\s*[$]url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
      "(?i)(^\s*[$]url64\s*=\s*)('.*')" = "`$1'$($Latest.URL64)'"
      "(?i)(^\s*[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(?i)(^\s*[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      "(?i)(^\s*[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
      "(?i)(^\s*[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
    }
  }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $regex   = '(?:/pgadmin/pgadmin4/v)(\d+(\.\d+)+)(?:/windows)'
  $url     = $download_page.links | Where-Object href -Match $regex | Select-Object -First 1 -Expand href
  $version = $url -replace ".*v(\d+(\.\d+)*).*",'$1'

  Write-Host $url $version

  $url32 = "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${version}/windows/pgadmin4-${version}-x86.exe"
  $url64 = "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${version}/windows/pgadmin4-${version}-x64.exe"

  return @{
    Version = $version

    URL32 = $url32
    URL64 = $url64
  }
}

Update-Package
