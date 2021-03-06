Xmonad Config for MacBook Air 11
================================

Contains xmonad config optimised for a Macbook Air 11 (Mid-2013) running Arch Linux. I can't take the credit for all the fancy stuff because I've simply adapted it from other people's configs.

![Alt text](/screenshot.png?raw=true "Screenshot")

The config includes the media keys to spawn things like keyboard light settings, volume, etc.

##Dependencies

* dzen2
* tint2
* conky
* kbdlight
* compton

##Additional programs 

Many of these get referenced in xprofile which I just symlink to ~/.xprofile. This gets read and invoked on entering xmonad from lightdm. 

* dunst - Provides desktop notifications

* cbatticon - Monitors the battery and shuts the laptop down if the battery gets too low. I'm only using systemd for power management.

* nm-applet - Works in conjunction with NetworkManager to manage network setup. 

* redshift - adjusts colour temp of the screen

* compton - I use this for the compositor - allows inactive windows to be faded and made transparent. Use the shadow-exclude to work around bugs in tint2.

* syndaemon - stop my mouse getting in the way when I don't want to use it.

* feh - set the wallpaper

* xcalib - calibrage the colour of the screen

* xmodmap - I have a UK keyboard which requires some tweaking to swap the grave and tilde keys

