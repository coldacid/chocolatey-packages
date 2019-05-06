Remove-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NtVdm64\0OTVDM' -Force
if (Get-OSArchitectureWidth -Compare 64) {
  Remove-Item 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\NtVdm64\0OTVDM' -Force
}
