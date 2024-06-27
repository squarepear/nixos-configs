{ config, pkgs, ... }:

{
  my.programs.obs-studio = {
    enable = config.pear.desktop.enable;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };
}
