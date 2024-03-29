Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$domain =   'https://github.com'
$releases = "$domain/otya128/winevdm/releases/latest"

function global:au_SearchReplace {
  @{
    ".\winevdm.nuspec" = @{
      "\<releaseNotes\>.+" = "<releaseNotes>$($Latest.ReleaseNotes)</releaseNotes>"
      "\<licenseUrl\>.+"   = "<licenseUrl>$($Latest.LicenseUrl)</licenseUrl>"
    }
    ".\legal\VERIFICATION.txt" = @{
      "(?i)https://github.com/otya128/winevdm/releases/download/.*"  = "$($Latest.URL)"
      "(?i)(^\s+checksum:).*"                                        = "`${1} $($Latest.Checksum)"
      "(?i)(^\s+Get-RemoteChecksum).*"                               = "`${1} $($Latest.URL)"
      "https://raw.githubusercontent.com/otya128/winevdm/.*/LICENSE" = $Latest.LicenseUrl
    }
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*[$]packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
      "(?i)(^\s*[$]zip\s*=\s*)('.*')"         = "`$1'$($Latest.Zip)'"
    }
  }
}

function global:au_BeforeUpdate {
  Get-RemoteFiles -Purge -NoSuffix -Algorithm sha256
  Invoke-WebRequest -Uri $Latest.LicenseUrl -OutFile .\legal\LICENSE.txt

  if (-Not (Test-Path ".\tools\$($Latest.Zip)")) {
    Invoke-WebRequest -Uri $Latest.URL -OutFile ".\tools\$($Latest.Zip)"
  }

  # For some reason Get-RemoteFiles doesn't always set the checksums :(
  If ([System.String]::IsNullOrEmpty($Latest.Checksum)) { $Latest.Checksum = $(Get-FileHash ".\tools\$($Latest.Zip)" -Algorithm SHA256).Hash }
}

function global:au_AfterUpdate { Set-DescriptionFromReadme -SkipFirst 2 -UseCData }

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $regex   = 'otvdm-.*\.zip$'
  $url     = $download_page.links | Where-Object href -Match $regex | Select-Object -First 1 -Expand href

  $verRE   = '/releases/tag/v(?<version>\d+(\.\d+)*)$'
  $verTag  = $download_page.links | Where-Object href -Match $verRE | Select-Object -First 1 -Expand href
  $version = $($verTag | Select-String $verRE).Matches.Groups[2].Value

  if (!$url.StartsWith($domain)) { $url = $domain + $url }

  $releaseNotesUrl = "$domain/otya128/winevdm/releases/tag/v" + $version
  $licenseUrl = 'https://raw.githubusercontent.com/otya128/winevdm/v' + $version + '/LICENSE'

  $trueVerRE = 'otvdm-v?(?<version>\d+(\.\d+)*)\.zip$'
  $trueVersion = $($url | Select-String $trueVerRE).Matches.Groups[2].Value;

  return @{
    Version = $trueVersion

    URL = $url
    Zip = Split-Path $url -Leaf

    ReleaseNotes = $releaseNotesUrl
    LicenseUrl = $licenseUrl
  }
}

Update-Package -ChecksumFor none -NoReadme
