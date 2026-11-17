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

  # Runs as the udev-triggered unit (no args) or as the NetworkManager
  # dispatcher script (interface and event as $1 and $2).
  rtw89LowLatency = pkgs.writeShellApplication {
    name = "rtw89-low-latency";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      tool=${lib.getExe pkgs.holo-realtek-firmware-toggles}

      if [ "$#" -ge 2 ]; then
        case "$2" in
          pre-up | up) ;;
          *) exit 0 ;;
        esac
      fi

      iface="''${1:-}"
      if [ -n "$iface" ]; then
        driver="$(readlink -f "/sys/class/net/$iface/device/driver" 2>/dev/null)" || exit 0
        case "$driver" in
          */rtw89*) ;;
          *) exit 0 ;;
        esac
      else
        for dev in /sys/class/net/*; do
          driver="$(readlink -f "$dev/device/driver" 2>/dev/null)" || continue
          case "$driver" in
            */rtw89*) iface="''${dev##*/}" ;;
          esac
        done
        if [ -z "$iface" ]; then
          echo "no rtw89 interface found" >&2
          exit 1
        fi
      fi

      "$tool" set-feature INACTIVE_PS off
      "$tool" set-pd-thresh -75

      # set-mcs-rates oopses the kernel unless the vif is associated.
      [ "$(cat "/sys/class/net/$iface/carrier" 2>/dev/null)" = 1 ] || exit 0

      "$tool" set-powersave off
      "$tool" set-amsdu off
      "$tool" set-mcs-rates 0-9
    '';
  };
in
{
  options.pear.programs.gaming.vr = {
    enable = lib.mkEnableOption "VR";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelPatches = [
      {
        name = "amdgpu-cap-sys-nice-begone";
        patch = ./kernel-pkgs/cap_sys_nice_begone.patch;
      }
      {
        name = "rtw89-reg6-pwr-override";
        patch = ./kernel-pkgs/rtw89-0001-reg6-pwr-override.patch;
        structuredExtraConfig.RTW89_DEBUGFS = lib.kernel.yes;
      }
      {
        name = "rtw89-disable-2ghz";
        patch = ./kernel-pkgs/rtw89-0002-disable-2ghz.patch;
      }
    ];

    boot.extraModprobeConfig = ''
      options rtw89_core disable_2ghz=Y reg6_pwr_override=1 disable_ps_mode=Y
    '';

    systemd.services.holo-realtek-firmware-toggles = {
      description = "Enable rtw89 low-latency mode for the Steam Frame wireless adapter";
      serviceConfig = {
        Type = "oneshot";
        ExecStartPre = lib.getExe waitForRtw89Debugfs;
        ExecStart = lib.getExe rtw89LowLatency;
      };
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="net", ACTION=="add|move", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2432", TAG+="systemd", ENV{SYSTEMD_WANTS}+="holo-realtek-firmware-toggles.service"
    '';

    networking.networkmanager.connectionConfig."wifi.powersave" = 3;

    networking.networkmanager.dispatcherScripts = [
      {
        source = rtw89LowLatency;
        type = "basic";
      }
    ];

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

      xdg.mimeApps.enable = true;
      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/vrmonitor" = "valve-vrmonitor.desktop;";
        "x-scheme-handler/steamvr" = "valve-steamvr.desktop;";
      };
    });

    environment.systemPackages = [
      pkgs.wayvr
      pkgs.bs-manager
      pkgs.android-tools
      pkgs.holo-realtek-firmware-toggles
    ];

    networking.firewall.allowedUDPPorts = [ 6767 ];

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
