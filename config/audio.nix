{ config, lib, pkgs, ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    wireplumber.enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  programs.noisetorch.enable = true;

  environment.systemPackages = with pkgs; lib.mkIf config.system.gui.enable [
    pavucontrol # Audio control panel
    helvum # audio channel manager
    pulseaudio # For pactl
  ];
}
