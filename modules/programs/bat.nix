{
  config,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.programs.bat;
in
{
  options.pear.programs.bat = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "minimal";
    };

    theme = lib.mkOption {
      type = lib.types.str;
      default = "Visual Studio Dark+";
    };

    tabs = lib.mkOption {
      type = lib.types.str;
      default = "2";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      programs.bat = {
        enable = true;
        config = {
          theme = cfg.theme;
          tabs = cfg.tabs;
        };
      };
    });
  };
}
