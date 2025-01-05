local wezterm = require 'wezterm';
return {
  -- Similar to my original scheme
  -- similar to: "Tomorrow Night", less contrast
  -- color_scheme = "Hybrid";
  -- Slightly more contrast, dark tone
  -- color_scheme = "Japanesque";
  -- Another mellow tone, prob not enough contrast tho.
  -- color_scheme = "Later This Evening";
  -- High contrast, reasonably dark
  -- color_scheme = "MaterialOcean";
  -- Nice dark theme, feels different in scheme
  -- color_scheme = "Neutron";
  -- Bright, Neon-like but still pretty readable,
  -- similar to: Sublette
  -- color_scheme = "Snazzy";
  color_scheme = "Tomorrow Night";
  font = wezterm.font("Fira Code", {weight="Medium"});
  -- font = wezterm.font("monospace");
  -- font = wezterm.font("JetBrains Mono");
  font_size = 9.0;
  line_height = 1.0;
  default_prog = {"fish"},
  enable_tab_bar = false,

  -- Fixes the insane broken front rendering.
  -- https://github.com/wez/wezterm/issues/5990
  -- https://github.com/wez/wezterm/issues/6005
  front_end = "WebGpu"
};
