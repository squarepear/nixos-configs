{ config, lib, pkgs, ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    wireplumber.enable = true;
    pulse.enable = true;
    media-session.enable = false;

    config.pipewire-pulse = {
      stream.properties = {
        channelmix.upmix = true;
        channelmix.upmix-method = "psd";
      };
    };
  };

  environment.systemPackages = with pkgs; lib.mkIf config.system.gui.enable [
    pavucontrol # Audio control panel
    helvum # audio channel manager
    pulseaudio # For pactl
  ];
}
