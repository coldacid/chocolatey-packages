Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$domain =   'https://bitbucket.com'
$repo   =   'jtuc/winmerge2011'
$releases = "$domain/$repo/downloads"
$tag_api  = "https://api.bitbucket.org/2.0/repositories/$repo/refs/tags"

function global:au_SearchReplace {
  @{
    ".\$($Latest.PackageName).nuspec" = @{
      "\<releaseNotes\>.+" = "<releaseNotes>$($Latest.ReleaseNotes)</releaseNotes>"
      "\<licenseUrl\>.+" = "<licenseUrl>$($Latest.LicenseUrl)</licenseUrl>"
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

function global:au_AfterUpdate { Set-DescriptionFromReadme -SkipFirst 2 }

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $regex   = '.*_change_7z_to_exe_if_you_want_a_setup\.7z$'
  $urls    = $download_page.links | Where-Object href -Match $regex | Select-Object -First 2 -Expand href
  $version = $urls[0] -split '_|.7z' | Select-Object -First 1 -Skip 1

  $url32 = $domain + ($urls | Where-Object { -not ($_ -like '*x64*') })
  $url64 = $domain + ($urls | Where-Object { $_ -like '*x64*' })

  $tag_data = Invoke-WebRequest -Uri "$tag_api/$version" | ConvertFrom-Json
  $commit = $tag_data.target.hash

  $releaseNotesUrl = "$domain/$repo/src/$commit/Docs/Users/CHANGES?at=" + $version
  $licenseUrl = "$domain/$repo/src/$commit/Src/COPYING?at=" + $version

  return @{
    Version = $version
    Commit = $commit

    URL32 = $url32
    Zip32 = Split-Path $url32 -Leaf
    URL64 = $url64
    Zip64 = Split-Path $url64 -Leaf

    ReleaseNotes = $releaseNotesUrl
    LicenseUrl = $licenseUrl
  }
}

Update-Package
