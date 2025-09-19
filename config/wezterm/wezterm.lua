local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- Font settings
config.font_size = 13
config.line_height = 1.1
config.font = wezterm.font("JetBrains Mono Medium")

-- Colors
config.colors = {
    cursor_bg = "white",
    cursor_border = "white",
}

config.color_scheme = 'Neon Night (Gogh)'

-- Appearance
-- config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
    left   = 0,
    right  = 0,
    top    = 0,
    bottom = 0,
}

-- Misc
config.max_fps = 100
config.prefer_egl = true

-- config.window_close_confirmation = 'AlwaysPrompt'
config.skip_close_confirmation_for_processes_named = {
    'bash',
    'sh',
    'zsh',
    'fish',
    'tmux',
    'nu',
    'cmd.exe',
    'pwsh.exe',
    'powershell.exe',
    'ncmpcpp',
}

return config
