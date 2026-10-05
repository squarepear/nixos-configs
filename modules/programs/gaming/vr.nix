{
  config,
  inputs,
  lib,
  pearlib,
  pkgs,
  unstable,
  ...
}:

let
  gamingCfg = config.pear.programs.gaming;
  cfg = gamingCfg.vr;

  system = pkgs.stdenv.hostPlatform.system;
in
{
  options.pear.programs.gaming.vr = {
    enable = lib.mkEnableOption "VR";
  };

  config = lib.mkIf cfg.enable {
    services.wivrn = {
      enable = true;
      package = inputs.wivrn.packages.${system}.default;

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
          bitrate = 200000000;
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

    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".config/bs-manager"
        ".config/wayvr"
        ".config/wivrn"
        ".local/share/BSManager"
        ".config/openvr"
        ".config/openxr"
        ".local/state/xrizer"
      ];
    });
  };
}
