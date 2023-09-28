Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = 'https://www.pgadmin.org/download/pgadmin-4-windows/'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyinstall.ps1" = @{
      "(?i)(^\s*[$]packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
      "(?i)(^\s*[$]url64\s*=\s*)('.*')" = "`$1'$($Latest.URL64)'"
      "(?i)(^\s*[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      "(?i)(^\s*[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
    }
  }
}

function global:au_GetLatest {
  $download_page        = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $regex                = '(?:/pgadmin/pgadmin4/v)(\d+(\.\d+)+)(?:/windows)'
  $url                  = $download_page.links | Where-Object href -Match $regex | Select-Object -First 1 -Expand href
  $version              = $url -replace ".*v(\d+(\.\d+)*).*",'$1'
  $releaseNotesVersion  = $version.replace(".", "_")

  Write-Host $url $version

  $url64 = "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${version}/windows/pgadmin4-${version}-x64.exe"
  $releaseNotesUrl = "https://www.pgadmin.org/docs/pgadmin4/${version}/release_notes_${releaseNotesVersion}.html"

  return @{
    Version = $version
    URL64 = $url64
    ReleaseNotes = $releaseNotesUrl
  }
}

Update-Package -ChecksumFor 64
