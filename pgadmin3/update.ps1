Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = 'https://www.pgadmin.org/download/pgadmin-3-windows/'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyinstall.ps1" = @{
      "(?i)(^\s*[$]packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
      "(?i)(^\s*[$]zip_file\s*=\s*)('.*')" = "`$1'$($Latest.Zip32)'"
      "(?i)(^\s*[$]zip_url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
      "(?i)(^\s*[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(?i)(^\s*[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $regex   = '(?:/pgadmin/pgadmin3/v)(\d+(\.\d+)+)(?:/win32)'
  $url     = $download_page.links | Where-Object href -Match $regex | Select-Object -First 1 -Expand href
  $version = $url -replace ".*v(\d+(\.\d+)*).*",'$1'

  $url32 = "https://ftp.postgresql.org/pub/pgadmin/pgadmin3/v${version}/win32/pgadmin3-${version}.zip"

  return @{
    Version = $version

    URL32 = $url32
    Zip32 = Split-Path $url32 -Leaf
  }
}

Update-Package
