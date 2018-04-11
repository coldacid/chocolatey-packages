<#
.SYNOPSIS
  Updates nuspec release notes from provided content

.DESCRIPTION
  This script should be called in au_AfterUpdate to put the provided text into the
  releaseNotes tag of the Nuspec file. The current release notes will be replaced.

.PARAMETER SkipFirst
  Number of start lines to skip from content, by default 0.

.PARAMETER SkipLast
  Number of end lines to skip from content, by default 0.

.EXAMPLE
  function global:au_AfterUpdate  { Set-ReleaseNotes $changelog -SkipFirst 1 }
#>
function Set-ReleaseNotes {
  Param(
    [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [Alias("changelog")]
    $ReleaseNotes,
    [int]$SkipFirst=0,
    [int]$SkipLast=0
  )

  Write-Host 'Setting Nuspec releaseNotes tag'
  $endIdx = $ReleaseNotes.Length - $SkipLast
  $releaseNotes = $releaseNotes | Select-Object -Index ($SkipFirst..$endIdx) | Out-String
  Write-Host "RELEASE NOTES:`n",$releaseNotes

  $nuspecFileName = Resolve-Path "*.nuspec"
  # We force gc to read as UTF8, otherwise nuspec files will be treated as ANSI
  # causing bogus/invalid characters to appear when non-ANSI characters are used.
  $nu = gc $nuspecFileName -Encoding UTF8 -Raw
  $nu = $nu -replace "(?smi)(\<releaseNotes\>).*?(\</releaseNotes\>)", "`${1}$($releaseNotes)`$2"

  $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($false)
  $NuPath = (Resolve-Path $NuspecFileName)
  [System.IO.File]::WriteAllText($NuPath, $nu, $Utf8NoBomEncoding)
}
