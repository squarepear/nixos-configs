{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = config.system.gui.enable;
    package = pkgs.firefox-wayland;
  };

  programs.browserpass = {
    enable = config.programs.firefox.enable;

    browsers = [ "firefox" ];
  };
}
