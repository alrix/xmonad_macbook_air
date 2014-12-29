Xmonad Config for MacBook Air 11
================================

Contains xmonad config optimised for macbook air running Arch Linux. I can't take the credit for all the fancy stuff because I've simply adapted it from other people's configs.

![Alt text](/alrix/xmonad_macbook_air/screenshot.png?raw=true "Screenshot")


##Dependencies

* dzen2
* tint2
* conky

##Additional programs 

These get referenced in xprofile which I just symlink to ~/.xprofile. This gets read and invoked on entering xmonad from lightdm. 

* cbatticon - Monitors the battery and shuts the laptop down if the battery gets too low. I'm only using systemd for power management.

* nm-applet - Works in conjunction with NetworkManager to manage network setup. 

* redshift - adjusts colour temp of the screen

* compton - I use this for the compositor - allows inactive windows to be faded and made transparent. Use the shadow-exclude to work around bugs in tint2.

* syndaemon - stop my mouse getting in the way when I don't want to use it.

* feh - set the wallpaper

* xcalib - calibrage the colour of the screen

* xmodmap - I have a UK keyboard which requires some tweaking to swap the grave and tilder keys

