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
        channelmix.mix-lfe = true;
        channelmix.upmix = true;
        channelmix.lfe-cutoff = 80;
      };
    };
  };

  environment.systemPackages = with pkgs; lib.mkIf config.system.gui.enable [
    pavucontrol # Audio control panel
    helvum # audio channel manager
  ];
}
