# winevdm on 64-bit Windows

> 16-bit Windows (Windows 1.x, 2.x, 3.0, 3.1, etc.) on 64-bit Windows

An altered version of winevdm (a 16-bit Windows emulator), ported to 64-bit
Windows.

This package installs winevdm for Windows and registers it so that 16-bit
Windows applications can be directly launched in 64-bit editions of Windows.
Alternatively you can call `otvdm.exe` with the path of the 16-bit Windows app
you wish to run, or `otvdmw.exe` to pick a 16-bit executable to run via the
Open File dialog.

This package also includes the Wine port of the WinHelp app for any applications
which use old-style WinHelp `.hlp` files for documentation.
