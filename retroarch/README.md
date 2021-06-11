# RetroArch

RetroArch is a frontend for libretro, an open API which exposes the functionality of a game, emulator or certain kinds of multimedia applications. libretro started as libsnes with the SNES emulator bSNES, but libretro has since become a far broader API. RetroArch builds around the libretro API to provide a powerful interface for libretro cores.

## Package Parameters

The following package parameters can be set:

* `/InstallDir:{path}` - Installation directory, defaults to `{tools-location}` (typically `C:\tools`)
* `/InstallationPath:{path}` - Alias for `/InstallDir`
* `/DesktopShortcut` - Add shortcut for RetroArch to the desktop.

## Notes

If a custom installation directory is used for RetroArch, shims will still be created for `retroarch.exe` and `retroarch_debug.exe` on the path so that RetroArch can be started from the command line as with prior versions of this package.

As of v1.9.1, the packaging method used by the RetroArch developers has changed. RetroArch now installs in its own `RetroArch-Win32` or `RetroArch-Win64` directory within the installation directory. This was not accounted for in the Chocolatey package until v1.9.4. If you have an older version of RetroArch installed, you may wish to uninstall it completely and then reinstall with Chocolatey instead of performing a simple upgrade.

Since v1.7.7 was released, the libretro/RetroArch developers have been uploading new builds without always updating the version. If you get checksum errors while installing RetroArch, this has probably happened again. Just [let us know](https://chocolatey.org/packages/retroarch/ContactOwners) via the Contact Maintainers link and a new package should be up on Chocolatey shortly after.
