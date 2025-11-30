{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.programs.gamedev;
in
{
  options.pear.programs.gamedev = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.allProfilesEnabled [
        "development"
        "desktop"
        "gaming"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    home-manager.users = pearlib.perUser (name: {
      home.packages = with pkgs; [
        godot_4_6
        gdscript-formatter
        blender
        krita
        aseprite
      ];
    });

    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".config/godot"
        ".local/share/godot"
        ".config/blender"
        ".config/aseprite"
      ];

      persist.files = [
        ".config/krita/kritarc"
      ];
    });
  };
}
