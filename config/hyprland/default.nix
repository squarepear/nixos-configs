{ config, pkgs, inputs, lib, ... }:

let
  pokedex = ''
    curl -s "https://pokeapi.co/api/v2/pokemon-species/643" | jq ".flavor_text_entries | .[] | select(.language.name == \"en\") | .flavor_text" | sed -e 's/ \\n//g' -e 's/\\n/ /g' -e 's/\\f/ /g' -e 's/\"//g' | sort -u | uniq | shuf -n 1
  '';
in
{
  imports = [
    ./conf.nix
    ./pkgs.nix
    ./mako.nix
    ./hyprlock.nix
    # ./hyprpaper.nix
    ./eww
  ];

  config = lib.mkIf (config.system.gui.wm == "hyprland") {
    my.imports = [
      inputs.hyprland.homeManagerModules.default
    ];

    services.greetd = {
      enable = true;
      package = pkgs.greetd.tuigreet;

      settings.default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet -tr --asterisks --greeting "$(${pokedex})" --cmd Hyprland
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
