{
  config,
  lib,
  pearlib,
  pkgs,
  unstable,
  ...
}:

let
  cfg = config.pear.programs.gaming;
  vendorCfg = config.pear.system.vendor;
in
{
  imports = [
    ./emulators.nix
    ./minecraft.nix
    ./steam.nix
    ./vr.nix
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
      package = unstable.gamescope;

      capSysNice = true;
    };

    programs.gamemode = {
      enable = true;
      # package = unstable.gamemode; # TODO: Only added in 26.11+

      enableRenice = true;
    };

    hardware.graphics.enable = true;
    hardware.amdgpu.overdrive.enable = lib.mkIf (vendorCfg.gpu == "amd") true;
    services.lact = {
      enable = true;

      settings = {
        version = 5;
        daemon = {
          log_level = "info";
          admin_group = "wheel";
          disable_clocks_cleanup = false;
        };
        apply_settings_timer = 5;
        profiles = {
          VR = {
            rule = {
              type = "process";
              filter = {
                name = "wayvr";
              };
            };
          };
        };
        current_profile = "VR";
        auto_switch_profiles = true;
      };
    };
  };
}
