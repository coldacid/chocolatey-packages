$programs = [System.Environment]::GetFolderPath("Programs");
Remove-Item "$programs\Biblioteq.lnk" -ErrorAction SilentlyContinue -Force | Out-Null
