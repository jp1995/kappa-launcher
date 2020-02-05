![alt text](https://cdn.discordapp.com/attachments/534004815160934410/674660498754764847/kappa64.png)
Kappa Launcher
============

Kappa Launcher is a simple bash script that uses rofi to display and launch your followed Twitch streams

Add video here

## Features

Displays all live Twitch streams that you follow.

Shows information about these streams, such as the currently played game, number of viewers and title.

Launches said streams

Supports streamlink, chatterino, chatty or just plain twitch in a browser.

Streams that you don't follow can also be launched

## Instructions

On first launch the script creates a configuration file in .config/kpl. You must then edit this file with your Twitch [OAuth token](https://twitchapps.com/tmi/). If you wish, you can also change the PLAYER and CHAT options.

Once you have done this, simply run the script again.

Dependencies include rofi, jq and xdg-utils. It's likely that you have the latter two installed. Optionally, you'll also need streamlink, chatterino and/or chatty.

## Additional info

I am not a programmer. This code is probably ugly, and could probably be written in a more clean, concise way. I welcome suggestions and constructive criticism.

In the future I might try displaying the game and viewer number alongside the streams in separate columns. I researched this idea and I didn't find an obvious way to achieve this.
