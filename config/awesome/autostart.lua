-- startup applications
--
-- Standard awesome library
local awful = require("awful")

awful.spawn.with_shell("setxkbmap -layout 'us, ru' -option 'grp:caps_toggle' -option 'terminate:ctrl_alt_bksp'")
awful.spawn.with_shell("xrdb -merge")
awful.spawn.with_shell("emacs --daemon")
-- awful.spawn.with_shell("nitrogen --restore")

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

-- entries must be separated by commas
run_once({ "devmon", "picom -b --experimental-backends", "mpd", "unclutter", "greenclip daemon", "corectrl", "dropbox-cli start"})
