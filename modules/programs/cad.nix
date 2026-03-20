{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.programs.cad;
in
{
  options.pear.programs.cad = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.allProfilesEnabled [
        "desktop"
        "development"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (name: {
      home.packages = with pkgs; [
        kicad # Electronics
        freecad-wayland # 3D Design
        openscad # 3D Design
        orca-slicer # 3D Printing
      ];
    });

    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".config/kicad"
        ".config/FreeCAD"
        ".config/Orca-Slicer"
      ];
    });
  };
}
