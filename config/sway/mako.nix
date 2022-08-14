{ config, ... }:

{
  my.programs.mako = {
    enable = config.my.wayland.windowManager.sway.enable;

    backgroundColor = "#2B303BAA";
  };
}
