{ config, pkgs, ... }:

{
  programs.eww = {
    enable = config.wayland.windowManager.sway.enable;
    package = pkgs.eww-wayland;

    configDir = ./eww-config;
  };
}
