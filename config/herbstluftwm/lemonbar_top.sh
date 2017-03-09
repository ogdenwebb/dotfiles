#!/bin/bash

source ~/.config/herbstluftwm/lemonbar.sh

while true; do
    # echo " $(herbstluftwmworkspaces) $(windowtitle)%{c} $(_time) %{r} $(mpd_song) "
    WS="%{A4:herbstclient use_index -1:}%{A5:herbstclient use_index +1:} $(herbstluftwmworkspaces)%{A}%{A}"
    echo " $WS $(windowtitle)%{c} $(_time) %{r} $(mpd_song) "
	sleep 0.1s
done | lemonbar -a 30 -g "x24xx" -B $BG -F $FG -f $FONT1 -f $FONT2 -f $FONT3 | sh
