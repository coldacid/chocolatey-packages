Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$domain =   'https://github.com'
$releases = "$domain/textbrowser/biblioteq/releases/latest"

function global:au_SearchReplace {
  @{
    ".\biblioteq.nuspec" = @{
      "\<licenseUrl\>.+"   = "<licenseUrl>$($Latest.LicenseUrl)</licenseUrl>"
    }
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*[$]packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
      "(?i)(^\s*[$]checksum\s*=\s*)('.*')"    = "`$1'$($Latest.Checksum32)'"
      "(?i)(^\s*[$]url\s*=\s*)('.*')"         = "`$1'$($Latest.URL)'"
    }
  }
}

function global:au_AfterUpdate { Set-DescriptionFromReadme -SkipFirst 2 -UseCData }

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $regex   = 'BiblioteQ\.zip$'
  $url     = $download_page.links | Where-Object href -Match $regex | Select-Object -First 1 -Expand href

  $verRE   = '/releases/tag/\d+(\.\d+)*$'
  $verTag  = $download_page.links | Where-Object href -Match $verRE | Select-Object -First 1 -Expand href
  $version = $verTag -split '/' | Select-Object -Last 1

  $url = $domain + $url

  $licenseUrl = 'https://raw.githubusercontent.com/textbrowser/biblioteq/' + $version + '/LICENSE'

  return @{
    Version = $version
    URL = $url
    LicenseUrl = $licenseUrl
  }
}

Update-Package -NoReadme
