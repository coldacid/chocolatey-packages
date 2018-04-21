# RetroArch

RetroArch is a frontend for libretro, an open API which exposes the functionality of a game, emulator or certain kinds of multimedia applications. libretro started as libsnes with the SNES emulator bSNES, but libretro has since become a far broader API. RetroArch builds around the libretro API to provide a powerful interface for libretro cores.

## Package Parameters

The following package parameters can be set:

* `/InstallDir:{path}` - Installation directory, defaults to Chocolatey tools directory.
* `/InstallationPath:{path}` - Alias for `/InstallDir`
* `/DesktopShortcut` - Add shortcut for RetroArch to the desktop.

## Notes

If a custom installation directory is used for RetroArch, shims will still be created for retroarch.exe and retroarch_debug.exe on the path so that RetroArch can be started from the command line as with prior versions of this package.
