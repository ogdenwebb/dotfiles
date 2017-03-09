#!/bin/sh
nitrogen --restore &
mpd &
conky &
compton -cGb &
xsetroot -cursor_name left_ptr &
setxkbmap -layout 'us, ru' -option 'grp:caps_toggle' &
# xrdb -merge ~/.Xresources &
dropbox start &
dunst &
devmon &
clipit -n &
unclutter -grab &
