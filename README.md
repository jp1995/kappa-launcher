![alt text](https://cdn.discordapp.com/attachments/534004815160934410/674660498754764847/kappa64.png)
Kappa Launcher
============

Kappa Launcher is a simple bash script that uses rofi to display and launch your followed Twitch streams

![output](https://cdn.discordapp.com/attachments/534004815160934410/674739062338355227/klm-optimized.gif)

## Features

* Displays all live Twitch streams that you follow.
* Shows information about these streams, such as the currently played game, number of viewers and title.
* Launches said streams, with the option of selecting video quality
* Supports streamlink, chatterino, chatty or just plain twitch in a browser.
* Streams that you don't follow can also be launched

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

#### If you wanna fuck around with the script
```bash
# Download the script, save it as kpl and make it executable
$ curl -L https://raw.githubusercontent.com/jp1995/kappa-launcher/master/kpl > kpl && chmod +x kpl
```

## Instructions
The binary is named ```kpl```

On first launch the script creates a configuration file in .config/kpl. You must then edit this file with your [Twitch OAuth token](https://twitchapps.com/tmi/). If you wish, you can also change the PLAYER and CHAT options here.

Once you have done this, simply run the script again.

Requirements:
* rofi
* jq
* streamlink.
Optionally, you'll also need chatterino or chatty for the chat client and xdg-utils for the browser function.

## To do

In the future I might try displaying the game and viewer number alongside the streams in separate columns. I looked into this a bit and I didn't find an obvious or easy way to achieve this.

Using streamlink to get the possible quality values is slow. Getting this from the twitch API would be a lot better.

## Additional info

I am not a programmer. This code is probably ugly, and could probably be written in a more clean, concise way. I welcome suggestions and constructive criticism.

i3 users (like me) can edit the launcher function to include some layout solution to further automatize the process. For example:
```
i3-msg "workspace number 3" &&
exec layout_manager.sh TWITCH
streamlink twitch.tv/...
```
