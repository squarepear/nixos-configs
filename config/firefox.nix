{ config, pkgs, ... }:

{
  my.programs.firefox = {
    enable = config.system.gui.enable;
    package = pkgs.firefox-wayland;
  };

  my.programs.browserpass = {
    enable = config.my.programs.firefox.enable;

    browsers = [ "firefox" ];
  };
}
