{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.system.fonts;
  desktopEnabled = pearlib.profileEnabled "desktop";
in
{
  options.pear.system.fonts = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = desktopEnabled;
      description = "Install and configure common fonts.";
    };

    enableFontconfig = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fontconfig.";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        nerd-fonts.ubuntu
        nerd-fonts.ubuntu-mono
        nerd-fonts.caskaydia-cove
        noto-fonts-color-emoji
      ];
      description = "Font packages to install system-wide.";
    };
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = cfg.enableFontconfig;

    fonts.packages = cfg.packages;
  };
}
