{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:

let
  gamingCfg = config.pear.programs.gaming;
  cfg = gamingCfg.vr;
in
{
  options.pear.programs.gaming.vr = {
    enable = lib.mkEnableOption "VR";
  };

  config = lib.mkIf cfg.enable {
    services.wivrn = {
      enable = true;
      package = unstable.wivrn;

      autoStart = true;
      openFirewall = true;
      highPriority = true;
      steam = lib.mkIf gamingCfg.steam.enable {
        enable = true;
        package = config.programs.steam.package;
        importOXRRuntimes = true;
      };

      config = {
        enable = true;

        json = {
          bitrate = 135000000;
          application = [ unstable.wayvr ];
        };
      };
    };

    environment.systemPackages = [
      unstable.bs-manager
      pkgs.sidequest
      pkgs.android-tools
    ];

    # ADB for Oculus Quest
    users.groups.adbusers = { };
    pear.users.adminGroups = [ "adbusers" ];
  };
}
