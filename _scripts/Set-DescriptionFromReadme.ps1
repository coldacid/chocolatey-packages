<#
.SYNOPSIS
  Updates nuspec file description from README.md

.DESCRIPTION
  This script should be called in au_AfterUpdate to put the text in the README.md
  into description tag of the Nuspec file. The current description will be replaced.
  Function will throw an error if README.md is not found.

.PARAMETER SkipFirst
  Number of start lines to skip from the README.md, by default 0.

.PARAMETER SkipLast
  Number of end lines to skip from the README.md, by default 0.

.PARAMETER CData
  Place the description inside a CDATA section.

.EXAMPLE
  function global:au_AfterUpdate  { Set-DescriptionFromReadme -SkipFirst 2 }
#>
function Set-DescriptionFromReadme([int]$SkipFirst=0, [int]$SkipLast=0, [switch]$UseCData) {
  if (!(Test-Path README.md)) { throw 'Set-DescriptionFromReadme: README.md not found' }

  Write-Host 'Setting README.md to Nuspec description tag'
  $description = gc README.md -Encoding UTF8
  $endIdx = $description.Length - $SkipLast
  $description = $description | select -Index ($SkipFirst..$endIdx) | Out-String

  $nuspecFileName = Resolve-Path "*.nuspec"
  # We force gc to read as UTF8, otherwise nuspec files will be treated as ANSI
  # causing bogus/invalid characters to appear when non-ANSI characters are used.
  $nu = gc $nuspecFileName -Encoding UTF8 -Raw
  if ($UseCData) {
    $nu = $nu -replace "(?smi)(\<description\>).*?(\</description\>)", "`${1}<![CDATA[$($description)]]>`$2"
  } else {
    $nu = $nu -replace "(?smi)(\<description\>).*?(\</description\>)", "`${1}$($description)`$2"
  }

  $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
  $NuPath = (Resolve-Path $NuspecFileName)
  [System.IO.File]::WriteAllText($NuPath, $nu, $Utf8NoBomEncoding)
}
