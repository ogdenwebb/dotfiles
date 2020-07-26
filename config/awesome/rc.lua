--[[

    Awesome WM configuration
    ./widgets/
    ./themes/

--]]

-- {{{ Required libraries
-- local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
-- local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

-- Standard awesome library
local gears         = require("gears")
local awful         = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox         = require("wibox")
-- Theme handling library
local beautiful     = require("beautiful")
-- Notification library
local naughty       = require("naughty")
local menubar       = require("menubar")

local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys")
my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Helper functions
local helpers = require("helpers")

-- Dynamic layout & other stuff
-- local dynamic = require("dynamic")

-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

local themes = {
    "ocean",            -- 1
}

-- local panel_themes = {
-- }

-- local bar_theme_name = panel_themes[1]

local chosen_theme = themes[1]
modkey       = "Mod4"
altkey       = "Mod1"

terminal     = "kitty"
rofi         = "rofi -show drun -sidebar-mode -modi \"window,ssh,drun\" -name-only"
editor       = os.getenv("EDITOR") or "vim"
gui_editor   = "emc"
browser      = "firefox-bin"
file_manager = "spacefm"
scrlocker    = "slock"


-- TODO: gap_single_client
awful.util.terminal = terminal
awful.util.tagnames = { "1", "2", "3", "4", "5" }
awful.layout.layouts = {
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.floating,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
}

awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = my_table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            --c:emit_signal("request::activate", "tasklist", {raise = true})<Paste>

            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 2, function (c) c:kill() end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = 250}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
-- }}}

-- Notification

-- -----------------------------------------------------
-- -- TODO: some options are not respected when the notification is created
-- -- through lib-notify. Naughty works as expected.

-- -- Icon size
-- naughty.config.defaults['icon_size'] = beautiful.notification_icon_size

-- -- Timeouts (set 0 for permanent)
-- naughty.config.defaults.timeout = 5
-- naughty.config.presets.low.timeout = 2
-- naughty.config.presets.critical.timeout = 0

-- -- Apply theme variables
-- naughty.config.defaults.padding = beautiful.notification_padding
-- naughty.config.defaults.spacing = beautiful.notification_spacing
-- naughty.config.defaults.margin = beautiful.notification_margin
-- naughty.config.defaults.border_width = beautiful.notification_border_width
-- -- Apply rounded rectangle shape
-- beautiful.notification_shape = function(cr, width, height)
--     gears.shape.rounded_rect(cr, width, height, beautiful.notification_border_radius)
-- end

-- naughty.config.presets.normal = {
--     font         = beautiful.notification_font,
--     fg           = beautiful.notification_fg,
--     bg           = beautiful.notification_bg,
--     border_width = beautiful.notification_border_width,
--     margin       = beautiful.notification_margin,
--     position     = beautiful.notification_position
-- }

-- naughty.config.presets.low = {
--     font         = beautiful.notification_font,
--     fg           = beautiful.notification_fg,
--     bg           = beautiful.notification_bg,
--     border_width = beautiful.notification_border_width,
--     margin       = beautiful.notification_margin,
--     position     = beautiful.notification_position
-- }

-- naughty.config.presets.ok = naughty.config.presets.low
-- naughty.config.presets.info = naughty.config.presets.low
-- naughty.config.presets.warn = naughty.config.presets.normal

-- naughty.config.presets.critical = {
--     font         = beautiful.notification_font,
--     fg           = beautiful.notification_crit_fg,
--     bg           = beautiful.notification_crit_bg,
--     border_width = beautiful.notification_border_width,
--     margin       = beautiful.notification_margin,
--     position     = beautiful.notification_position
-- }

-- {{{ Menu
myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}

mymainmenu = awful.menu({
    -- icon_size = beautiful.menu_height or 16,
    items = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        { "Terminal", terminal },
        { "File manager", file_namager },
        { "Run", rofi },
        { "Reboot", "sudo reboot" },
        { "Poweroff", "sudo poweroff" },
        
    }
})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

-- hide menu when mouse leaves it
--awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function() awful.util.mymainmenu:hide() end)

--menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it
-- }}}

-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
-- screen.connect_signal("property::geometry", function(s)
--     -- Wallpaper
--     if beautiful.wallpaper then
--         local wallpaper = beautiful.wallpaper
--         -- If wallpaper is a function, call it with the screen
--         if type(wallpaper) == "function" then
--             wallpaper = wallpaper(s)
--         end
--         gears.wallpaper.maximized(wallpaper, s, true)
--     end
-- end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)
-- }}}

-- {{{ Mouse bindings
root.buttons(my_table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- Load key bindings
require("keys")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
      properties = { titlebars_enabled = false } },

    -- Set Firefox to always map on the first tag on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = awful.util.tagnames[1] } },

    { rule = { class = "Gimp", role = "gimp-image-window" },
          properties = { maximized = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 2, function() c:kill() end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = 16}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = true})
-- end)

-- No border for maximized clients
function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end

client.connect_signal("property::maximized", border_adjust)
client.connect_signal("focus", border_adjust)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- possible workaround for tag preservation when switching back to default screen:
-- https://github.com/lcpz/awesome-copycats/issues/251
-- }}}

--- {{{ Disable DPMS while full screen window
local fullscreened_clients = {}

local function remove_client(tabl, c)
    local index = awful.util.table.hasitem(tabl, c)
    if index then
        table.remove(tabl, index)
        if #tabl == 0 then
            awful.spawn("xset s on")
            awful.spawn("xset +dpms")
        end
    end
end

client.connect_signal("property::fullscreen",
    function(c)
        if c.fullscreen then
            table.insert(fullscreened_clients, c)
            if #fullscreened_clients == 1 then
                awful.spawn("xset s off")
                awful.spawn("xset -dpms")
            end
        else
            remove_client(fullscreened_clients, c)
            end
end)

client.connect_signal("unmanage",
    function(c)
        if c.fullscreen then
            remove_client(fullscreened_clients, c)
        end
end)
--- }}}

-- {{{ Autostart
require("autostart")
-- }}}
