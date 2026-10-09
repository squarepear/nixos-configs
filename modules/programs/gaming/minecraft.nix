{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  minecraftCfg = config.pear.programs.gaming;
  cfg = minecraftCfg.minecraft;
in
{
  options.pear.programs.gaming.minecraft = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = minecraftCfg.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (name: {
      home.packages = [
        pkgs.prismlauncher
      ];
    });

    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".local/share/PrismLauncher"
      ];
    });
  };
}
