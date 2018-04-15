Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = 'https://confluence.atlassian.com/bitbucket/bitbucket-lfs-media-adapter-856699998.html'
$checksumType = 'sha256'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyinstall.ps1" = @{
      "(?i)(^\s*[$]packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
      "(?i)(^\s*[$]url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
      "(?i)(^\s*[$]url64\s*=\s*)('.*')" = "`$1'$($Latest.URL64)'"
      "(?i)(^\s*[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(?i)(^\s*[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      "(?i)(^\s*[$]checksumType\s*=\s*)('.*')" = "`$1'$($checksumType)'"
    }
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum32 = Get-RemoteChecksum -Url $Latest.URL32 -Algorithm $checksumType
  $Latest.Checksum64 = Get-RemoteChecksum -Url $Latest.URL64 -Algorithm $checksumType

  mkdir .\tmp
  $filename = Join-Path '.\tmp' $(Split-Path $Latest.URL32 -Leaf)
  Invoke-WebRequest -Uri $Latest.URL32 -OutFile $filename
  $changelog = $(7z e -so $filename README.md).Where({ $_ -like '## Changelog' }, 'SkipUntil')
  rm -r .\tmp
  $Latest.ReleaseNotes = $changelog | ForEach-Object { $_ } # convert to string array
}

function global:au_AfterUpdate {
  Set-DescriptionFromReadme -SkipFirst 2
  Set-ReleaseNotes $Latest.ReleaseNotes -SkipFirst 2
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $regex   = 'win(dows)?-.*\.zip$'
  $urls    = $download_page.links | Where-Object href -Match $regex | Select-Object -First 2 -Expand href
  $version = $urls[0] -split '-|.zip' | Select-Object -Last 1 -Skip 1

  $url32 = ($urls | Where-Object { $_ -like '*386*' })
  $url64 = ($urls | Where-Object { $_ -like '*amd64*' })

  return @{
    Version = $version

    URL32 = $url32
    URL64 = $url64
  }
}

Update-Package -ChecksumFor none -NoReadme
