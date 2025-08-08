{ config, pkgs, ... }:

{
  programs.obs-studio = {
    enable = config.pear.desktop.enable;
    enableVirtualCamera = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      droidcam-obs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
}
