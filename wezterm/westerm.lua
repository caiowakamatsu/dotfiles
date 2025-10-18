local wezterm = require 'wezterm'
return {
  font = wezterm.font_with_fallback({"JetBrains Mono", "Iosevka Term"}),
  font_size = 12.0,
  window_background_opacity = 0.90,
  macos_window_background_blur = 20,
  color_scheme = "Builtin Dark",
	window_decorations = "RESIZE",
	enable_tab_bar = false,
	use_resize_increments = false,
	enable_wayland = false,
  colors = {
    background = "#0C0F14",
    foreground = "#E0E1DD",
    cursor_bg = "#6EE2FF",
    cursor_fg = "#0C0F14",
  },
}
