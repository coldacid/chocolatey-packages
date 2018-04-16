Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$domain =   'https://github.com'
$releases = "$domain/EWSoftware/SHFB/releases/latest"

function global:au_SearchReplace {
  @{
    ".\$($Latest.PackageName).nuspec" = @{
      "\<releaseNotes\>.+" = "<releaseNotes>$($Latest.ReleaseNotes)</releaseNotes>"
    }
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*[$]packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
      "(?i)(^\s*[$]versionNumber\s*=\s*)('.*')" = "`$1'$($Latest.Version)'"
      "(?i)(^\s*[$]url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
      "(?i)(^\s*[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(?i)(^\s*[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $regex   = 'SHFBInstaller_v.*\.zip$'
  $url    = $download_page.links | Where-Object href -Match $regex | Select-Object -First 1 -Expand href
  $version = $url -split '_v|.zip' | Select-Object -Last 1 -Skip 1

  $url32 = $domain + $url

  $releaseNotesUrl = "$domain/EWSoftware/SHFB/releases/tag/v" + $version

  return @{
    Version = $version

    URL32 = $url32

    ReleaseNotes = $releaseNotesUrl
  }
}

Update-Package
