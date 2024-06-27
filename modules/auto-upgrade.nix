{ config, lib, ... }:

with lib;

let
  cfg = config.pear.autoUpgrade;
in
{
  options.pear.autoUpgrade = {
    enable = mkEnableOption "automatic upgrading of the system flake";

    flake = mkOption {
      type = types.str;
      default = "github:squarepear/nixos-configs";
    };
  };

  config = mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;

      randomizedDelaySec = "30min";

      inherit (cfg) flake;
    };
  };
}
