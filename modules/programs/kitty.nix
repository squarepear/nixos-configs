{
  config,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.programs.kitty;

  fontName = cfg.font.name;
  fontSize = cfg.font.size;
in
{
  options.pear.programs.kitty = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "desktop";
      description = "Enable kitty for all users (home-manager).";
    };

    font = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "CaskaydiaCove Nerd Font Mono";
      };

      size = lib.mkOption {
        type = lib.types.int;
        default = 20;
      };
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        window_padding_width = 12;
        confirm_os_window_close = 3;
      };
      description = "Extra kitty settings merged into the config.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      programs.kitty = {
        enable = true;
        font = {
          name = fontName;
          size = fontSize;
        };

        # Home-manager kitty uses `settings` attrset.
        settings = cfg.settings;
      };
    });
  };
}
