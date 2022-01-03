{ config, ... }:

{
  programs.mako = {
    enable = config.wayland.windowManager.sway.enable;

    backgroundColor = "#2B303BAA";
  };
}
