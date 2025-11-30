{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  desktopCfg = config.pear.desktop;
  usersCfg = config.pear.users;
in
{
  config = lib.mkIf (desktopCfg.enable && desktopCfg.environment == "hyprland") {
    services.displayManager.ly.enable = true;

    programs.hyprland = {
      enable = true;
      withUWSM = true;

      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    # home-manager.users = lib.genAttrs (lib.attrNames usersCfg.users) (name: {
    #   imports = [
    #     inputs.hyprland.homeManagerModules.default
    #   ];

    #   wayland.windowManager.hyprland = {
    #     enable = true;

    #     package = null;
    #     portalPackage = null;
    #   };
    # });

    # Fix for UWSM `A compositor or graphical-session* target is already active!` error
    services.displayManager.ly.x11Support = false;
    systemd.user.targets.nixos-fake-graphical-session = lib.mkForce { };
  };
}
