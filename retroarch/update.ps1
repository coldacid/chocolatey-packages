Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = "http://retroarch.com/index.php?page=platforms"

function global:au_SearchReplace {
  @{
    ".\$($Latest.PackageName).nuspec" = @{
      "\<licenseUrl\>.+" = "<licenseUrl>$($Latest.LicenseUrl)</licenseUrl>"
      "\<iconUrl\>.+" = "<iconUrl>https://cdn.rawgit.com/libretro/RetroArch/v$($Latest.Version)/media/retroarch-96x96.png</iconUrl>"
      "\<releaseNotes\>.+" = "<releaseNotes>$($Latest.ReleaseNotes)</releaseNotes>"
    }
    ".\tools\chocolateyInstall.ps1" = @{
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
  $regex   = '/windows/x86(_64)?/'
  $urls    = $download_page.links | Where-Object href -Match $regex | Select-Object -First 4 -Expand href
  $version = $urls[0] -split '/' | Select-Object -Last 1 -Skip 3

  $url32 = "https://buildbot.libretro.com/stable/${version}/windows/x86/RetroArch.7z"
  $url64 = "https://buildbot.libretro.com/stable/${version}/windows/x86_64/RetroArch.7z"

  $releaseNotesUrl = "https://github.com/libretro/RetroArch/releases/tag/v" + $version
  $licenseUrl = "https://github.com/libretro/RetroArch/blob/v" + $version + '/COPYING'

  return @{
    Version = $version

    URL32 = $url32
    URL64 = $url64

    ReleaseNotes = $releaseNotesUrl
    LicenseUrl = $licenseUrl
  }
}

Update-Package
