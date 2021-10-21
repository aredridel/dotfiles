local wezterm = require 'wezterm';
return {
  font = wezterm.font_with_fallback({"Triplicate T4", "SF Mono", "LastResort"}),
  color_scheme = "Builtin Tango Dark",
  scrollback_lines = 3500,
  initial_rows = 70,
  initial_cols = 200,
  
  leader = { key="a", mods="CTRL" },
  keys = {
    {key="v", mods="LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key="h", mods="LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    {key="a", mods="LEADER|CTRL", action=wezterm.action{SendString="\x01"}},
    {key="l", mods="SUPER", action="ShowLauncher"},
    {key="r", mods="SUPER", action="ReloadConfiguration"},
  },

  ssh_domains = {
    {
      name = "asty.zt.dinhe.net",
      remote_address = "asty.zt.dinhe.net",
    },
    {
      name = "mizar.zt.dinhe.net",
      remote_address = "mizar.zt.dinhe.net",
    }
  }
}
