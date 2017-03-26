#!/bin/bash

# Colors
BG="#1B1B1B"
BG2="#333333"
FG="#d6d6d6"
# DIM="#a9a9a9"
DIM="#767676"
# GREEN="#5d8383"
GREEN="#459769"
# GREEN="#457397"
GREEN2="#5d8370"
BLUE="#5d7083"
PURPLE="#835d83"
YELLOW="#d2ab5d"
RED="#d75f5f"

# Panel
PW=1920
PH=24
PX=0
PY=0

# Fonts
FONT1="Hack:size=11"
FONT2="FontAwesome:size=12"
FONT3="IPAGothic:size=12" # for japanese characters

i3workspaces() {

    # array=$(i3-msg -t get_workspaces | tr , '\n' | grep '"name":' | cut -d : -f 2 | cut -d '"' -f 2)
    current_workspace=$(i3-msg -t get_workspaces | jq '.[] | select(.focused).name' | cut -d '"' -f 2)

    echo -e -n "%{F$GREEN2}\uf101 %{F$DIM} " # left arrow

    # Set number of workspaces
    count=5
    for i in $(seq 1 $count) ; do
        active=$(i3-msg -t get_workspaces | tr , '\n' | grep '"name":' | cut -d : -f 2 | cut -d '"' -f 2 | grep $i)

        # Check if ws is current
        if [ "$i" == "$current_workspace" ]; then
            echo -n "%{$BG}%{F$PURPLE}"
        # Check if ws is active(has clients)
        elif [ "$active" != "" ]; then
            echo -n "%{$BG}%{F$DIM}"
        # For other empty ws
        else
            echo -n "%{$BG}%{F$BG2}"
        fi

        # Print icon for all workspaces
        echo -e -n "%{A:i3-msg workspace $i:}\uf111%{A}"
        echo -n " %{F$DIM}"
    done
}

windowtitle() {
    TITLE=$(xdotool getactivewindow getwindowname 2>/dev/null | sed -n 1p || echo "")
    if [ "$TITLE" != "" ]; then
        echo -e -n "%{F$GREEN}\uf26c %{F$FG}"

        # Set maximum title size
        title_size=70
        if [ "${#TITLE}" -ge $title_size ]; then
            TITLE="${TITLE:0:$title_size} ..."
        fi
        echo -e -n "$TITLE"
    fi
}

kernel() {

    KERNEL=$(uname -a | awk '{print $3"_"$13}')
    echo -e -n "Kernel: $KERNEL"
}

battery() {

    BATPERC=$(acpi --battery | cut -d, -f2 | awk '{print $1}' | tr -d '%')
    if [ "$BATPERC" != "" ]; then
        if [ "$(echo $BATPERC ' > 90' | bc)" = 1 ]; then
            echo -e -n "\uf240"
        elif [ "$(echo $BATPERC ' > 60' | bc)" = 1 ]; then
            echo -e -n "\uf241"
        elif [ "$(echo $BATPERC ' > 30' | bc)" = 1 ]; then
            echo -e -n "\uf242"
        elif [ "$(echo $BATPERC ' > 10' | bc)" = 1 ]; then
            echo -e -n "\uf243"
        else
            echo -e -n "\uf244"
        fi
        echo -e -n " $BATPERC%"
    else
        echo "No battery plugged in"
    fi
}

_date() {

    DATE=$(date +'%A, %B %e')

    echo -e -n "%{F$YELLOW}\uf017 %{F$FG}$DATE"
}

_time()
{
    TIME=$(date +'%H:%M')

    # echo -e -n "$TIME"
    echo -e -n "%{F$GREEN2}\uf142%{F$FG} %{A:lilyterm -e vim -c Calendar:} $TIME %{A} %{F$GREEN2}\uf142%{F$FG}"
}

temperature() {

    CPU_TEMP=$(sensors | grep "Physical id 0" | cut -d+ -f2 | cut -d. -f1)
    echo -e -n "CPU Temperature: $CPU_TEMP"
}

memory() {
    MEMORYUSED=$(free -m | awk '/^Mem/ {print $3}')
    echo -e -n "\uf1c0 $MEMORYUSED"
}

mpd_song() {
    ARTIST=$(mpc -f %artist% current)
    SONG=$(mpc -f %title% current)
    if [[ -n $ARTIST ]] || [[ -n $SONG ]]; then
        # Set maximum song size
        song_size=60
        if [ "${#SONG}" -ge $song_size ]; then
            SONG="${SONG:0:$song_size} ..."
        fi

        artist_size=30
        if [ "${#ARTIST}" -ge $artist_size ]; then
            ARTIST="${ARTIST:0:$artist_size} ..."
        fi

        TITLE="%{A1:mpc toggle:}%{A4:mpc prev:}%{A5:mpc next:}$ARTIST - $SONG%{A}%{A}%{A}"
        echo -e -n "%{F$GREEN2}\uf105 %{F$FG} $TITLE "
    else
        echo -n "No music playing "
    fi
    echo -e -n " %{F$GREEN2}\uf100 %{F$FG}"
}

mpd_volume() {

    VOLUME=$(mpc volume | cut -d' ' -f2)
    echo -e -n "\uf028 $VOLUME"
}

mpd_progress() {

    MPCSTATUS=$(mpc status | grep -E "(playing|paused)" -0)
    PROGRESS=$(mpc status | grep -E "(playing|paused)" | rev | cut -c 3- | rev | cut -d "(" -f 2)
    FULL=$((PROGRESS / 2))
    SHADE=$((50 - full))

    if [ "$MPCSTATUS" == "playing" ]; then
        icon="\ue034"
    else
        icon="\ue037"
    fi

    echo -e -n "%{A:mpc -q prev && ${UPDATE}:} \ue045%{A}%{A:mpc -q toggle && ${UPDATE}:} " $icon
}

volume() {

    VOLUME=$(pulseaudio-ctl full-status | awk '{split($0, array, " ")} END{print array[1]}')
    MUTE=$(pulseaudio-ctl full-status | awk '{split($0, array, " ")} END{print array[2]}')
    if [ "$MUTE" == "yes" ]; then
        echo -e -n "\uf026"
    else
        echo -e -n "\uf028 $VOLUME%"
    fi
}

wifi_ssid() {

    NAME=$(iwconfig wlp3s0 | grep 'ESSID:' | awk '{print $4, $5, $6, $7}' | sed 's/ESSID://g' | sed 's/"//g')
    if [ "$NAME" == "off/any   " ]; then
        echo -e -n "No connection"
    else
        echo -e -n " $NAME"
    fi
}

wifi_strength() {

    SIGNAL=$(iwconfig wlp3s0 | grep "Link Quality" | cut -d"=" -f2 | cut -d "/" -f1 )
    #WIFI=$(($SIGNAL / 70 * 100))
    if [ "$SIGNAL" != "" ]; then
        echo -e -n "$SIGNAL%"
    fi
}
