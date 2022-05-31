![alt text](https://cdn.discordapp.com/attachments/534004815160934410/674660498754764847/kappa64.png)
Kappa Launcher
============

Kappa Launcher is a simple bash script that uses rofi to display and launch your followed Twitch streams.

![output](https://github.com/jp1995/ctf_docs/blob/main/stuff/kpl.gif)

## Features

* Displays all live Twitch streams that you follow.
* Shows information about these streams, such as the currently played game, number of viewers and title.
* Launches said streams, with the option of selecting video quality.
* Supports streamlink, chatterino, chatty or just plain twitch in a browser.
* Streams that you don't follow can also be looked up and launched.

## Installation
### LATEST VERSION: 01 MARCH 2022. HELIX API MIGRATION. UPDOOT UR SHIT.

### Install using ```make```
```bash
# Clone the repo
$ git clone https://github.com/jp1995/kappa-launcher

# Change your current directory to kappa-launcher
$ cd kappa-launcher

# Install it
$ sudo make install
```

### AUR package
For Arch based distros, an [AUR package](https://aur.archlinux.org/packages/kappa-launcher-git/) is available at
```bash
yay -S kappa-launcher-git
```

## Instructions
The binary (executable) is named ```kpl```.

On first launch the script creates a configuration file in .config/kpl. You must then edit this file with your [Twitch OAuth token](https://jp1995.github.io/kappa/). If you wish, you can also change various other options here.

Once you have done this, simply run the script again.

Requirements:
* rofi
* jq
* streamlink

Optionally, you'll also need chatterino or chatty for the chat client and xdg-utils for the browser function.

## Problems / to do

Using streamlink to get the possible quality values is slow. Getting this from the twitch API would be a lot better. However, this is currently not possible.

## Additional info

I am not an actual programmer. This code could likely be written in a more clean, concise way. I welcome suggestions and constructive criticism.

i3 users can edit the launcher function to include some layout solution to further automatize the process. For example:
```
i3-msg "workspace number 3" &&
exec layout_manager.sh TWITCH
streamlink twitch.tv/...
```
