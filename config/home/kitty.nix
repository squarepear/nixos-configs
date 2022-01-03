{ config, ... }:

{
  programs.kitty = {
    enable = config.system.gui.enable;

    font = {
      name = "CaskaydiaCove Nerd Font Mono";
      size = 16;
    };

    settings = {
      window_padding_width = 12;
      background_opacity = "0.925";
    };
  };
}
