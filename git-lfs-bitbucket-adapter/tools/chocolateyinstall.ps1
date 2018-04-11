$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'git-lfs-bitbucket-adapter'
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url         = 'https://downloads.atlassian.com/software/bitbucket/GitLfsBitbucketAdapter-windows-386-1.0.6.zip'
$url64       = 'https://downloads.atlassian.com/software/bitbucket/GitLfsBitbucketAdapter-darwin-amd64-1.0.6.zip'
$checksum    = 'ea51b5d258b745d877d84201ec182953c9ba98eb551c4b11b549768b654a62e4'
$checksum64  = '724fb5f54bfaacf593f0bc79087067de8029890823e2f40ccf976898cfcab03b'
$checksumType= 'sha256'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir

  url           = $url
  url64bit      = $url64

  checksum      = $checksum
  checksumType  = $checksumType
  checksum64    = $checksum64
  checksumType64= $checksumType
}

Install-ChocolateyZipPackage @packageArgs

$adapter = $(Join-Path $toolsDir 'git-lfs-bitbucket-media-api').Replace('\', '/')
git config --global lfs.customtransfer.bitbucket-media-api.path $adapter
