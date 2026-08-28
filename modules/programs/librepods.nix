{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:
let
  cfg = config.pear.programs.librepods;
in
{
  options.pear.programs.librepods = {
    enable = lib.mkEnableOption "librepods (AirPods feature controls for Linux)";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.librepods;
      defaultText = lib.literalExpression "pkgs.librepods";
      description = "The LibrePods package to install.";
    };

    spoofDeviceId = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Spoof the Bluetooth DeviceID in /etc/bluetooth/main.conf to advertise as an
        Apple device (bluetooth:004C:0000:0000). Required to unlock Apple-gated
        AirPods features such as hearing aid, loud sound reduction, and
        conversational awareness.
      '';
    };

    enableAvrcpPlayer = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable bluez5.dummy-avrcp-player in WirePlumber so AirPods media
        play/pause/next/previous controls work over Bluetooth.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.groups.librepods = { };

    users.users = pearlib.perUser (_: {
      extraGroups = [ "librepods" ];
    });

    security.wrappers.librepods = {
      source = lib.getExe cfg.package;
      capabilities = "cap_net_admin+ep";
      owner = "root";
      group = "librepods";
      permissions = "u+rx,g+x";
    };

    hardware.bluetooth.settings = lib.mkIf cfg.spoofDeviceId {
      General = {
        DeviceID = "bluetooth:004C:0000:0000";
      };
    };

    services.pipewire.wireplumber.extraConfig = lib.mkIf cfg.enableAvrcpPlayer {
      "50-librepods-avrcp" = {
        "monitor.bluez5.properties" = {
          "bluez5.dummy-avrcp-player" = true;
        };
      };
    };

    pear.system.impermanence.users = pearlib.perUser (_: {
      persist.directories = [
        ".config/librepods"
        ".config/autostart"
      ];
    });

    # Headless daemon: runs once per session on graphical-session.target and
    # keeps the AirPods control loop / A2DP takeover alive in the background.
    home-manager.users = pearlib.perUser (_: {
      systemd.user.services.librepods = {
        Unit = {
          Description = "LibrePods (AirPods feature controls for Linux)";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe cfg.package} --no-tray";
          Restart = "on-failure";
          RestartSec = 5;
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    });
  };
}
