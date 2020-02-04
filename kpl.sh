#!/bin/bash

# Setting working directory
if [ -z "$XDG_CONFIG_HOME" ]; then
  MAIN_PATH=~/kpl
else
  MAIN_PATH="$XDG_CONFIG_HOME/kpl/"
fi

# Grab configuration file
source $MAIN_PATH/config

# Checking dependencies
JQ_BIN="$(whereis -b jq | awk '{print $2}')"
ROFI_BIN="$(whereis -b rofi | awk '{print $2}')"

if [ -z "$JQ_BIN" ]; then
  echo "Kappa launcher dependency not found: jq"
  exit 1
fi
if [ -z "$ROFI_BIN" ]; then
  echo "Kappa launcher dependency not found: rofi"
  exit 1
fi

# General rofi parameters
_rofi () {
  rofi -dmenu -i -no-custom -no-levenshtein-sort -disable-history -scroll-method 1 \
  -theme-str 'inputbar { children: [prompt];}' "$@"
}

# Setting OAuth key, connecting to Twitch API and retrieving followed data
# This is a slightly edited version of https://github.com/begs/livestreamers/blob/master/live.py

curl -s -o $MAIN_PATH/followdata.json -H 'Accept: application/vnd.twitchtv.v5+json' \
-H 'Client-ID: 3lyhpjkzellmam3843w7eq3es84375' \
-H 'Authorization: OAuth 71ptfgoixj0vrold0y8mxf7yq3ck4j' \
-X GET 'https://api.twitch.tv/kraken/streams/followed' \

# Getting names of currently live streams
x=1
while [[ $x -le 1 ]]; do
  STREAMS=$(jq -r '.streams[].channel.display_name' $MAIN_PATH/followdata.json)

  # Listing said streams with rofi
  MAIN=$(echo "$STREAMS" | _rofi -p "Followed channels:")
  if [ -z "$MAIN" ]; then
    exit
  fi
  # Retrieving additional information
  CURRENT_GAME=$(jq -r ".streams[].channel | select(.display_name==\"$MAIN\") | .game"  $MAIN_PATH/followdata.json)
  STATUS=$(jq -r ".streams[].channel | select(.display_name==\"$MAIN\") | .status"  $MAIN_PATH/followdata.json)
  VIEWERS=$(jq -r ".streams[] | select(.channel.display_name==\"$MAIN\") | .viewers"  $MAIN_PATH/followdata.json)

  # Prompting with stream info and options
  CHOICE=$(echo "$STATUS

<b>Watch now</b>
Back to Followed Channels" | _rofi -width 35 -lines 5 -selected-row 2 -markup-rows \
-p "$MAIN is streaming $CURRENT_GAME to $VIEWERS viewers")

  if [[ "$CHOICE" = "<b>Watch now</b>" ]]; then
    if [[ "$PLAYER" = "streamlink" ]]; then
      killall -9 vlc &    # This is required because VLC is annoying. If you use a different media player, remove this line.
      streamlink twitch.tv/$MAIN best &
      echo "launching $PLAYER"
      if [[ "$CHAT" = "chatterino" ]]; then
        chatterino &
      elif [[ "$CHAT" = "chatty" ]]; then
        chatty
      else
        echo "Chat not defined in config file"
      fi
    elif [[ "$PLAYER" = "browser" ]]; then
      xdg-open https://twitch.tv/$MAIN
    else
      echo "Player not defined in config file"
    fi
    x=$(( $x + 1))
  elif [[ "$CHOICE" = "Back to Followed Channels" ]]; then
    return
  else [ -z "$MAIN" ];
    exit
  fi

done
