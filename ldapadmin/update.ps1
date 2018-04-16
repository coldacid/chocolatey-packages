Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = 'http://www.ldapadmin.org/download/ldapadmin.html'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyinstall.ps1" = @{
      "(?i)(^\s*[$]packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
      "(?i)(^\s*[$]version\s*=\s*)('.*')" = "`$1'$($Latest.Version)'"
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
  $regex   = 'w(32|64)-.*\.zip/download$'
  $urls    = $download_page.links | Where-Object href -Match $regex | Select-Object -First 2 -Expand href
  $version = $urls[0] -split '-|.zip' | Select-Object -Last 1 -Skip 1

  $url32 = "https://downloads.sourceforge.net/project/ldapadmin/ldapadmin/${version}/LdapAdminExe-w32-${version}.zip"
  $url64 = "https://downloads.sourceforge.net/project/ldapadmin/ldapadmin/${version}/LdapAdminExe-w64-${version}.zip"

  return @{
    Version = $version

    URL32 = $url32
    URL64 = $url64
  }
}

Update-Package
