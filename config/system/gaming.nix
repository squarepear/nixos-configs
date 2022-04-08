{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.system.gui.enable {
    environment.systemPackages = with pkgs; [
      polymc # Minecraft launcher
      lutris # General games

      retroarchFull # General emulator
      citra # 3DS emulator
      dolphin-emu-beta # Wii/GameCube emulator

      steam-run-native

      # Proton tools
      protonup
      proton-caller

      # Hardware monitor
      mangohud
    ];

    # Enable Steam
    programs.steam = {
      enable = true;

      remotePlay.openFirewall = true;
    };

    # Enable Steam hardware
    hardware.steam-hardware.enable = true;

    # Fixes some broken games
    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };

    # Add GameCube controller support
    services.udev.packages = [ pkgs.dolphinEmu ];
  };
}
