{ config, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.kodi-wayland.passthru.withPackages (kodiPackages: with kodiPackages; [
      jellyfin
      joystick
      netflix
      steam-launcher
      youtube
    ]))
  ];
}
