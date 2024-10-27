{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./conf.nix
    ./eww
    ./hyprlock.nix
    # ./hyprpaper.nix
    ./mako.nix
    ./pkgs.nix
    # ./plugins.nix
    ./split-monitor-workspace.nix
  ];

  config = lib.mkIf (config.pear.desktop.wm == "hyprland") {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    my.imports = [
      inputs.hyprland.homeManagerModules.default
    ];

    services.greetd = {
      enable = true;
      package = pkgs.greetd.tuigreet;

      settings.default_session = {
        command = ''
          ${lib.getExe pkgs.greetd.tuigreet} -tr --asterisks --greeting "$(${lib.getExe pkgs.pokedex})" --cmd Hyprland
        '';
      };
    };

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    my.wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };
}
