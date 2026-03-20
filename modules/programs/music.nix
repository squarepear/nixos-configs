{
  config,
  lib,
  pearlib,
  unstable,
  ...
}:

let
  cfg = config.pear.programs.music;
in
{
  options.pear.programs.music = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "desktop";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (name: {
      home.packages = [
        unstable.cider-2
      ];
    });

    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".config/sh.cider.genten"
      ];
    });
  };
}
