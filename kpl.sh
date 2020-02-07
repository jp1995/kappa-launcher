#!/bin/bash

# Checking dependencies
JQ_BIN="$(whereis -b jq | awk '{print $2}')"
ROFI_BIN="$(whereis -b rofi | awk '{print $2}')"
STREAMLINK_BIN="$(whereis -b streamlink |awk '{print $2}')"

if [ -z "$JQ_BIN" ]; then
  echo "ERROR: Kappa Launcher dependency not found: jq"
  exit 1
fi
if [ -z "$ROFI_BIN" ]; then
  echo "ERROR: Kappa Launcher dependency not found: rofi"
  exit 1
fi
if [ -z "$STREAMLINK_BIN" ]; then
  echo "ERROR: Kappa Launcher dependency not found: streamlink"
  echo "If you only intend to use the browser function, you will not need this"
fi

# Some functions
_config () {
  mkdir -p $MAIN_PATH
  cat << EOF >$FILE
# Either streamlink or browser, default streamlink
PLAYER=streamlink

# Either chatterino or chatty, default chatterino. Irrelevant when using browser.
CHAT=chatterino

# OAuth
OAUTH=replace_this_with_oauth_string
EOF
}

_filecheck () {
  if [ -f "$FILE" ]; then
    echo "Configuration file found, proceeding"
  else
    echo "First start detected, generating configuration file"
    _config
    echo ""
    echo "Configuration file created in .config/kpl"
    echo ""
    echo "Edit it with your OAuth key and relaunch the script"
    exit
  fi
}

_rofi () {
  rofi -dmenu -i -no-levenshtein-sort -disable-history -scroll-method 1 "$@"
}

_launcher () {
  if [[ "$PLAYER" = "streamlink" ]]; then
    killall -9 vlc &    # This is required because VLC is annoying. If you use a different media player, remove this line.
    streamlink twitch.tv/$MAIN $QUALITY &
    echo "launching $PLAYER"
    if [[ "$CHAT" = "chatterino" ]]; then
      chatterino &
    elif [[ "$CHAT" = "chatty" ]]; then
      chatty
    else
      echo "ERROR: Chat not defined in config file"
    fi
  elif [[ "$PLAYER" = "browser" ]]; then
    xdg-open https://twitch.tv/$MAIN
  else
    echo "ERROR: Player not defined in config file"
  fi
  y=$(( $x + 1))
  x=$(( $x + 1))
}

_quality () {
  RESOLUTION=$(streamlink twitch.tv/$MAIN | grep -i  audio_only | cut -c 19- | tr , '\n' | tac | cut -d ' ' -f 2)
  QUALITY=$(echo "$RESOLUTION" | _rofi -theme-str 'inputbar { children: [prompt];}' -no-custom -p "Select stream quality")
}

# Setting working directory, checking for configuration file, generating it if needed

if [ -z "$XDG_CONFIG_HOME" ]; then
  FILE=~/.config/kpl/config
  MAIN_PATH=~/.config/kpl
  _filecheck
else
  FILE=$XDG_CONFIG_HOME/kpl/config
  MAIN_PATH=$XDG_CONFIG_HOME/kpl
  _filecheck
fi

# Grab configuration file
source $MAIN_PATH/config

# Setting OAuth key, connecting to Twitch API and retrieving followed data
# This is a slightly edited version of https://github.com/begs/livestreamers/blob/master/live.py

curl -s -o $MAIN_PATH/followdata.json -H "Accept: application/vnd.twitchtv.v5+json" \
-H "Client-ID: 3lyhpjkzellmam3843w7eq3es84375" \
-H "Authorization: OAuth $OAUTH" \
-X GET "https://api.twitch.tv/kraken/streams/followed" \

# Checking if json file is properly populated
if grep -q "invalid oauth token" "$MAIN_PATH/followdata.json"; then
  echo "ERROR: json file not populated, make sure you only copied your OAuth string, and not the preceeding 'oauth:' section"
  exit
else
  echo "json file successfully populated"
fi

# Getting names of currently live streams
x=1
y=1
while [[ $x -le 1 ]]; do
  y=1
  QUALITY=best
  STREAMS=$(jq -r '.streams[].channel.display_name' $MAIN_PATH/followdata.json)

  # Listing said streams with rofi
  MAIN=$(echo "$STREAMS" | _rofi -theme-str 'inputbar { children: [prompt,entry];}' -p "Followed channels: ")
  if [[ "$STREAMS" != *"$MAIN"* ]]; then
    _launcher
  elif [ -z "$MAIN" ]; then
    exit
  else
    # Retrieving additional information
    CURRENT_GAME=$(jq -r ".streams[].channel | select(.display_name==\"$MAIN\") | .game"  $MAIN_PATH/followdata.json)
    STATUS=$(jq -r ".streams[].channel | select(.display_name==\"$MAIN\") | .status"  $MAIN_PATH/followdata.json)
    VIEWERS=$(jq -r ".streams[] | select(.channel.display_name==\"$MAIN\") | .viewers"  $MAIN_PATH/followdata.json)

    # Prompting with stream info and options
    while [[ $y -le 1 ]]; do
    CHOICE=$(echo "$STATUS

<b>Watch now</b>
Choose quality (default = best)
Back to Followed Channels" | _rofi -theme-str 'inputbar { children: [prompt];}' -selected-row 2 -no-custom -markup-rows -p "$MAIN is streaming $CURRENT_GAME to $VIEWERS viewers")

    if [[ "$CHOICE" = "<b>Watch now</b>" ]]; then
      _launcher
    elif [[ "$CHOICE" = "Choose quality (default = best)" ]]; then
      _quality
    elif [[ "$CHOICE" = "Back to Followed Channels" ]]; then
      y=$(( $x + 1))
    else [ -z "$MAIN" ];
      exit
    fi
  done
  fi
done
exit
