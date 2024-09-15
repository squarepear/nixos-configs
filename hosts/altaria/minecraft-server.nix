{ config, inputs, pkgs, ... }:
let
  serverPath = "/data/harmon_family_game_servers/mc_vanilla";

  nix-minecraft = inputs.nix-minecraft;
in
{
  networking.firewall = {
    allowedTCPPorts = [ 25555 ];
    allowedUDPPorts = [ 24444 ];
  };

  containers.hfgs-mc-vanilla = {
    config = { lib, pkgs, ... }: {
      imports = [ nix-minecraft.nixosModules.minecraft-servers ];
      nixpkgs.overlays = [ nix-minecraft.overlay ];
      nixpkgs.config.allowUnfree = true;

      services.minecraft-server = {
        enable = true;
        eula = true;
        openFirewall = true;

        package = pkgs.fabricServers.fabric-1_21_1;
        dataDir = "/data";
        jvmOpts = "-Xms12288M -Xmx12288M --add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15";
      };

      users.users.minecraft = {
        uid = lib.mkForce 1000;
        group = lib.mkForce "users";
      };

      system.stateVersion = "24.11";
    };

    autoStart = true;

    forwardPorts = [
      {
        containerPort = 25555;
        hostPort = 25555;
        protocol = "tcp";
      }
      {
        containerPort = 24444;
        hostPort = 24444;
        protocol = "udp";
      }
    ];

    bindMounts = {
      "/data" = {
        hostPath = serverPath;
        isReadOnly = false;
      };
    };
  };
}
