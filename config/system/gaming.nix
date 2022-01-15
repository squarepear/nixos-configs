{ config, lib, pkgs, ... }:
let
  # Include java8 and java17 in multimc
  multimc = pkgs.multimc.overrideAttrs (oldAttrs: rec {
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.jdk8 pkgs.jdk17 ];
  });
in
{
  config = lib.mkIf config.system.gui.enable {
    environment.systemPackages = with pkgs; [
      multimc # Minecraft launcher
      lutris # General games

      retroarchFull # General emulator
      citra # 3DS emulator
      dolphin-emu-beta # Wii/GameCube emulator 

      # Proton tools
      protonup
      proton-caller
    ];

    # Enable Steam
    programs.steam = {
      enable = true;

      remotePlay.openFirewall = true;
    };

    # Enable Steam hardware
    hardware.steam-hardware.enable = true;

    # Fixes some broken games
    hardware.opengl.driSupport32Bit = true;

    # Add GameCube controller support
    services.udev.packages = [ pkgs.dolphinEmu ];
  };
}
