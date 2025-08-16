local wezterm = require 'wezterm'
local colors = dofile(os.getenv('HOME')..'/colors.lua')
return {
  colors = colors,
  font = wezterm.font('FiraCode Nerd Font', {weight='Regular'}),
  font_size = 12.0,
  color_scheme = 'SkogsLjus',
  window_background_opacity = 0.9,
  enable_tab_bar = false,
}
