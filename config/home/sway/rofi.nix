{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rofi-power-menu
  ];

  programs.rofi = {
    enable = config.wayland.windowManager.sway.enable;
    package = pkgs.rofi-wayland;

    font = "Ubuntu Mono Nerd Font 20";
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = "docu";
    pass.enable = true;

    extraConfig = {
      modi = "drun,ssh";
      matching = "fuzzy";
      show-icons = true;
    };
  };
}
