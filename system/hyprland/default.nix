{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./conf.nix
    ./pkgs.nix
    ./mako.nix
    ./hyprlock.nix
    # ./hyprpaper.nix
    ./eww
  ];

  config = lib.mkIf (config.pear.desktop.wm == "hyprland") {
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
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    my.wayland.windowManager.hyprland.enable = true;
  };
}
