{
  config,
  lib,
  pearlib,
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
    environment.systemPackages = [
      unstable.wayvr
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
