{
  config,
  lib,
  pearlib,
  pkgs,
  unstable,
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
      home.packages = [
        unstable.godot_4_6
        unstable.gdscript-formatter
        pkgs.blender
        pkgs.krita
        pkgs.aseprite

        # itch.io command-line tool for uploading game builds
        pkgs.butler
      ];
    });

    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".config/godot"
        ".local/share/godot"
        ".config/blender"
        ".config/aseprite"
        ".config/itch"
      ];

      persist.files = [
        ".config/krita/kritarc"
      ];
    });
  };
}
