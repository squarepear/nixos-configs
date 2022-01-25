{ config, lib, pkgs, ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    # alsa.enable = true;
    # alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  environment.systemPackages = with pkgs; lib.mkIf config.system.gui.enable [
    pavucontrol # Audio control panel
  ];
}
