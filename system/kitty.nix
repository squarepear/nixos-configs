{ config, ... }:

let
  inherit (config.my.colorScheme) palette;
in
{
  my.programs.kitty = {
    enable = config.pear.desktop.enable;

    font = {
      name = "CaskaydiaCove Nerd Font Mono";
      size = 20;
    };

    settings = {
      window_padding_width = 12;
      confirm_os_window_close = 3;
      foreground = "#${palette.base05}";
      background = "#${palette.base00}";
      selection_background = "#${palette.base05}";
      selection_foreground = "#${palette.base00}";
      url_color = "#${palette.base04}";
      cursor = "#${palette.base05}";
      active_border_color = "#${palette.base03}";
      inactive_border_color = "#${palette.base01}";
      active_tab_background = "#${palette.base00}";
      active_tab_foreground = "#${palette.base05}";
      inactive_tab_background = "#${palette.base01}";
      inactive_tab_foreground = "#${palette.base04}";
      tab_bar_background = "#${palette.base01}";
      color0 = "#${palette.base00}";
      color1 = "#${palette.base08}";
      color2 = "#${palette.base0B}";
      color3 = "#${palette.base0A}";
      color4 = "#${palette.base0D}";
      color5 = "#${palette.base0E}";
      color6 = "#${palette.base0C}";
      color7 = "#${palette.base05}";
      color8 = "#${palette.base03}";
      color9 = "#${palette.base08}";
      color10 = "#${palette.base0B}";
      color11 = "#${palette.base0A}";
      color12 = "#${palette.base0D}";
      color13 = "#${palette.base0E}";
      color14 = "#${palette.base0C}";
      color15 = "#${palette.base07}";
      color16 = "#${palette.base09}";
      color17 = "#${palette.base0F}";
      color18 = "#${palette.base01}";
      color19 = "#${palette.base02}";
      color20 = "#${palette.base04}";
      color21 = "#${palette.base06}";

    };
  };
}
