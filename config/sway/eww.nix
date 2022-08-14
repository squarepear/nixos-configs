{ config, pkgs, ... }:

{
  my.programs.eww = {
    enable = config.my.wayland.windowManager.sway.enable;
    package = pkgs.eww-wayland;

    configDir = ./eww-config;
  };
}
