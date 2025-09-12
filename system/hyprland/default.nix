{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./conf.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./mako.nix
    ./menu.nix
    ./pkgs.nix
    # ./plugins.nix
    ./split-monitor-workspace.nix
    ./quickshell
  ];

  config = lib.mkIf (config.pear.desktop.wm == "hyprland") {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    my.imports = [
      inputs.hyprland.homeManagerModules.default
    ];

    services.displayManager.ly.enable = true;

    programs.hyprland = {
      enable = true;
      withUWSM = true;

      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    my.wayland.windowManager.hyprland = {
      enable = true;

      package = null;
      portalPackage = null;
    };

    # Fix for UWSM `A compositor or graphical-session* target is already active!` error
    services.displayManager.ly.x11Support = false;
    systemd.user.targets.nixos-fake-graphical-session = lib.mkForce { };
  };
}
