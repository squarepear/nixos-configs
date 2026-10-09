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

      capSysNice = true;
    };

    programs.gamemode = {
      enable = true;

      enableRenice = true;
    };

    hardware.graphics.enable = true;
    hardware.amdgpu.overdrive.enable = lib.mkIf (vendorCfg.gpu == "amd") true;
    services.lact = {
      enable = true;

      settings = {
        version = 7;
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

    # LACT refuses to start if a stale socket is left behind by a crash.
    systemd.services.lactd.serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/rm -f /run/lactd.sock";
  };
}
