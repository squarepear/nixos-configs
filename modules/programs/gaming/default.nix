{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.programs.gaming;
  vendorCfg = config.pear.system.vendor;
in
{
  imports = [
    ./steam.nix
    ./emulators.nix
  ];

  options.pear.programs.gaming = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "gaming";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (name: {
      home.packages = with pkgs; [
        mangohud
      ];
    });

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    hardware.graphics.enable = true;
    hardware.amdgpu.overdrive.enable = lib.mkIf (vendorCfg.gpu == "amd") true;
    services.lact.enable = true;
  };
}
