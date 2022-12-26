{ config, pkgs, ... }:
let

  serverPath = "/data/harmon_family_game_servers/mc_vanilla++";

in
{
  networking.firewall = {
    allowedTCPPorts = [ 25555 23333 ];
    allowedUDPPorts = [ 24444 ];
  };

  containers.hfgs-vanillapp = {
    autoStart = true;

    forwardPorts = [
      {
        containerPort = "25555";
        hostPort = "25555";
        protocol = "tcp";
      }

      {
        containerPort = "23333";
        hostPort = "23333";
        protocol = "tcp";
      }

      {
        containerPort = "24444";
        hostPort = "24444";
        protocol = "udp";
      }
    ];

    bindMounts = {
      "/data" = {
        hostPath = serverPath;
        isReadOnly = false;
      };
    };

    config = { config, pkgs, lib, ... }: {
      services.minecraft-server = {
        enable = true;
        package = pkgs.emptyDirectory;

        eula = true;
        dataDir = "/data/server";
      };

      systemd.services = {
        "minecraft-server" = {
          description = lib.mkForce "Vanilla++ Minecraft Server";
          after = [ "packwiz.service" ];
          requires = [ "packwiz.service" ];

          serviceConfig = {
            ExecStartPre = lib.mkForce "${pkgs.temurin-bin-17}/bin/java -jar packwiz-installer-bootstrap.jar -g -s server http://[::1]:23333/pack.toml";
            ExecStart = lib.mkForce ''
              ${pkgs.temurin-bin-17}/bin/java -Xms10G -Xmx10G \
                --add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true \
                -jar quilt-server-launch.jar nogui
            '';
          };

          path = with pkgs; [
            temurin-bin-17
          ];
        };


        "packwiz" = {
          description = "Vanilla++ Packwiz Server";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.packwiz}/bin/packwiz serve --port 23333";
            WorkingDirectory = "/data/modpack";
            User = "minecraft";
          };

          path = with pkgs; [
            packwiz
          ];
        };
      };

      networking.firewall = {
        enable = true;

        allowedTCPPorts = [ 25555 23333 ];
        allowedUDPPorts = [ 24444 ];
      };

      system.stateVersion = "23.05";
    };
  };
}
