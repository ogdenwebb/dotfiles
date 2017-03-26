#!/bin/bash

if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
    printf "%s\n" "The status bar is already running." >&2
    exit 1
fi

source ~/.config/i3/lemonbar.sh

while true; do
    # echo " $(herbstluftwmworkspaces) $(windowtitle)%{c} $(_time) %{r} $(mpd_song) "
    WS="%{A4:i3-msg workspace next:}%{A5:i3-msg workspace prev:} $(i3workspaces)%{A}%{A}"
    echo " $WS $(windowtitle)%{c} $(_time) %{r} $(mpd_song) "
        sleep 0.1s
done | lemonbar -a 30 -g "x24xx" -B $BG -F $FG -f $FONT1 -f $FONT2 -f $FONT3 | sh
