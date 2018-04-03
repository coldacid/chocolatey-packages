Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$domain =   'https://github.com'
$releases = "$domain/tomnomnom/gron/releases/latest"

function global:au_SearchReplace {
  @{
    ".\gron.nuspec" = @{
      "\<releaseNotes\>.+" = "<releaseNotes>$($Latest.ReleaseNotes)</releaseNotes>"
    }
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(^\s+x32:).*"        = "`${1} $($Latest.URL32)"
      "(?i)(^\s+checksum32:).*" = "`${1} $($Latest.Checksum32)"
      "(?i)(^\s+x64:).*"        = "`${1} $($Latest.URL64)"
      "(?i)(^\s+checksum64:).*" = "`${1} $($Latest.Checksum64)"
      "(?i)(^\s+Get-RemoteChecksum).*(# 32-bit)" = "`${1} $($Latest.URL32)  `${2}"
      "(?i)(^\s+Get-RemoteChecksum).*(# 64-bit)" = "`${1} $($Latest.URL64)  `${2}"
      "https://raw.githubusercontent.com/tomnomnom/gron/.*/LICENSE" = $Latest.LicenseUrl
    }
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*[$]packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
      "(?i)(^\s*[$]zip32\s*=\s*)('.*')" = "`$1'$($Latest.Zip32)'"
      "(?i)(^\s*[$]zip64\s*=\s*)('.*')" = "`$1'$($Latest.Zip64)'"
    }
  }
}

function global:au_BeforeUpdate {
  Get-RemoteFiles -Purge -NoSuffix -Algorithm sha256
  Invoke-WebRequest -Uri $Latest.LicenseUrl -OutFile .\legal\LICENSE.txt

  # For some reason Get-RemoteFiles doesn't always set the checksums :(
  If ($Latest.Checksum32 -eq '') { $Latest.Checksum32 = $(Get-FileHash ".\tools\$($Latest.Zip32)" -Algorithm SHA256).Hash }
  If ($Latest.Checksum64 -eq '') { $Latest.Checksum64 = $(Get-FileHash ".\tools\$($Latest.Zip32)" -Algorithm SHA256).Hash }
}
function global:au_AfterUpdate { Set-DescriptionFromReadme -SkipFirst 2 }

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $regex   = 'win(dows)?-.*\.zip$'
  $urls    = $download_page.links | Where-Object href -Match $regex | Select-Object -First 2 -Expand href
  $version = $urls[0] -split '-|.zip' | Select-Object -Last 1 -Skip 1

  $url32 = $domain + ($urls | Where-Object { $_ -like '*386*' })
  $url64 = $domain + ($urls | Where-Object { $_ -like '*amd64*' })

  $releaseNotesUrl = "$domain/tomnomnom/gron/releases/tag/v" + $version
  $licenseUrl = 'https://raw.githubusercontent.com/tomnomnom/gron/v' + $version + '/LICENSE'

  return @{
    Version = $version

    URL32 = $url32
    Zip32 = Split-Path $url32 -Leaf
    URL64 = $url64
    Zip64 = Split-Path $url64 -Leaf

    ReleaseNotes = $releaseNotesUrl
    LicenseUrl = $licenseUrl
  }
}

Update-Package -ChecksumFor none
