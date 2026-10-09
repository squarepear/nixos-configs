{
  config,
  lib,
  pearlib,
  pkgs,
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
    # Patch amdgpu as an out-of-tree module instead of rebuilding the whole
    # kernel. See https://wiki.nixos.org/wiki/VR#Applying_as_a_NixOS_kernel_patch
    boot.extraModulePackages = [
      (pkgs.callPackage ./amdgpu-kernel-module.nix {
        kernel = config.boot.kernelPackages.kernel;
        patches = [
          (pkgs.fetchpatch {
            name = "cap_sys_nice_begone.patch";
            url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
            hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
          })
        ];
      })
    ];

    systemd.user.services.wayvr = {
      description = "WayVR desktop overlay for OpenXR/OpenVR";
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.wayvr}/bin/wayvr --replace";
        Restart = "on-failure";
      };
    };

    home-manager.users = pearlib.perUser (name: {
      xdg.configFile."openxr/1/active_runtime.json" = {
        force = true;
        text = ''
          {
             "file_format_version": "1.0.0",
              "runtime": {
              "VALVE_runtime_is_steamvr": true,
              "library_path": "/home/${name}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrclient.so",
              "name": "SteamVR"
              }
          }
        '';
      };
    });

    environment.systemPackages = [
      pkgs.wayvr
      pkgs.bs-manager
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
