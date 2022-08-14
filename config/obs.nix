{ config, pkgs, ... }:

{
  my.programs.obs-studio = {
    enable = config.system.gui.enable;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };
}
