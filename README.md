![alt text](https://cdn.discordapp.com/attachments/534004815160934410/674660498754764847/kappa64.png)
Kappa Launcher
============

Kappa Launcher is a simple bash script that uses rofi to display and launch your followed Twitch streams.

+<img src="https://spheroid.xyz/kappa/kpl.gif?raw=true" width="200px">

## Features

* Displays all live Twitch streams that you follow.
* Shows information about these streams, such as the currently played game, number of viewers and title.
* Launches said streams, with the option of selecting video quality.
* Supports streamlink, chatterino, chatty or just plain twitch in a browser.
* Streams that you don't follow can also be looked up and launched.

## Installation
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

#### If you want to play around with the script
```bash
# Download the script, save it as kpl and make it executable
$ curl -L https://raw.githubusercontent.com/jp1995/kappa-launcher/master/kpl > kpl && chmod +x kpl
```

## Instructions
The binary (executable) is named ```kpl```.

On first launch the script creates a configuration file in .config/kpl. You must then edit this file with your [Twitch OAuth token](https://spheroid.xyz/kappa/). If you wish, you can also change the STREAM, CHAT and PLAYER options here.

Once you have done this, simply run the script again.

Requirements:
* rofi
* jq
* streamlink

Optionally, you'll also need chatterino or chatty for the chat client and xdg-utils for the browser function.

## Problems / to do

Using streamlink to get the possible quality values is slow. Getting this from the twitch API would be a lot better. However, this is currently not possible.

## Additional info

I am not an actual programmer. This code is probably ugly, and could likely be written in a more clean, concise way. I welcome suggestions and constructive criticism.

i3 users (like me) can edit the launcher function to include some layout solution to further automatize the process. For example:
```
i3-msg "workspace number 3" &&
exec layout_manager.sh TWITCH
streamlink twitch.tv/...
```
