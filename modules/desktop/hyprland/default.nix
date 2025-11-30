{
  config,
  inputs,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.desktop.hyprland;

  defaultMonitors = [
    {
      output = "DP-3";
      mode = "3840x2160@60";
      position = "0x0";
      scale = 1;
      transform = 1;
      bitdepth = 10;
    }
    {
      output = "DP-2";
      mode = "3840x2160@240";
      position = "auto-center-right";
      scale = 1;
      bitdepth = 10;
    }
    {
      output = "";
      mode = "preferred";
      position = "auto";
      scale = 1;
    }
  ];
in
{

  imports = [
    ./conf/binds.nix
    ./conf/rules.nix
    ./conf/settings.nix
    ./quickshell
    ./hm-base.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./mako.nix
    ./tofi.nix
  ];

  options.pear.desktop.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "desktop";
    };

    monitors = lib.mkOption {
      type = with lib.types; listOf attrs;
      default = defaultMonitors;
      description = "Hyprland monitor v2 configuration.";
    };

    primaryMonitor = lib.mkOption {
      type = lib.types.str;
      default = "DP-2";
      description = "Primary monitor name used for hyprlock widgets.";
    };

    wallpaper = lib.mkOption {
      type = lib.types.path;
      default = /home/jeffrey/Pictures/Wallpapers/wallpaper.jpg;
      description = "Wallpaper path used by hyprpaper.";
    };

    enableQuickshell = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Quickshell";
    };

    enableSplitMonitorWorkspaces = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable split monitor workspaces feature in Hyprland.";
    };
  };

  config = lib.mkIf cfg.enable {
    pear.desktop = {
      enable = lib.mkForce true;
      environment = lib.mkForce "hyprland";
    };

    pear.programs = {
      vscode.enable = true;
      kitty.enable = true;
    };

    services.displayManager.ly.enable = true;

    programs.hyprland = {
      enable = true;
      withUWSM = true;

      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    # Fix for UWSM `A compositor or graphical-session* target is already active!` error
    services.displayManager.ly.x11Support = false;
    systemd.user.targets.nixos-fake-graphical-session = lib.mkForce { };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
