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

  # The driver creates the debugfs interface slightly after the netdev appears,
  # so the udev-triggered unit waits briefly for it before running the tool.
  waitForRtw89Debugfs = pkgs.writeShellApplication {
    name = "wait-for-rtw89-debugfs";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      for _ in $(seq 1 40); do
        if ls -d /sys/kernel/debug/ieee80211/*/rtw89 >/dev/null 2>&1; then
          exit 0
        fi
        sleep 0.5
      done
      echo "timed out waiting for the rtw89 debugfs interface" >&2
      exit 1
    '';
  };
in
{
  options.pear.programs.gaming.vr = {
    enable = lib.mkEnableOption "VR";
  };

  config = lib.mkIf cfg.enable {
    # Patch amdgpu as an out-of-tree module instead of rebuilding the whole
    # kernel. See https://wiki.nixos.org/wiki/VR#Applying_as_a_NixOS_kernel_patch
    boot.extraModulePackages = [
      (pkgs.callPackage ./kernel-pkgs/amdgpu-kernel-module.nix {
        kernel = config.boot.kernelPackages.kernel;
      })
      # Rebuild just the rtw89 module with CONFIG_RTW89_DEBUGFS enabled so the
      # holo-realtek-firmware-toggles debugfs interface exists, without a full
      # kernel rebuild.
      (pkgs.callPackage ./kernel-pkgs/rtw89-debugfs.nix {
        kernel = config.boot.kernelPackages.kernel;
      })
    ];

    boot.extraModprobeConfig = ''
      options rtw89_core disable_2ghz=Y reg6_pwr_override=1
    '';

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

    # Enable rtw89 low-latency mode for the Steam Frame wireless dongle once it
    # appears. The unit runs as root, so the tool skips its pkexec escalation.
    systemd.services.holo-realtek-firmware-toggles = {
      description = "Enable rtw89 low-latency mode for the Steam Frame wireless adapter";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStartPre = lib.getExe waitForRtw89Debugfs;
        ExecStart = "${lib.getExe pkgs.holo-realtek-firmware-toggles} set-low-latency-mode on";
      };
    };

    # Trigger the unit when the dongle's network interface is created
    # (USB 28de:2432, driver rtw89_8852cu).
    services.udev.extraRules = ''
      SUBSYSTEM=="net", ACTION=="add", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2432", TAG+="systemd", ENV{SYSTEMD_WANTS}+="holo-realtek-firmware-toggles.service"
    '';

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
      pkgs.holo-realtek-firmware-toggles
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
