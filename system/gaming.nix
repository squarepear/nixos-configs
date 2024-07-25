{ config, inputs, lib, pkgs, ... }:

{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  config = lib.mkIf config.pear.desktop.enable {
    # Nix-Gaming settings
    nix.settings = {
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };

    # Pipewire low latency audio
    services.pipewire.lowLatency.enable = true;
    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      prismlauncher # Minecraft launcher
      lutris # General games

      # Emulators
      sameboy # GB/GBC
      mgba # GBA
      melonDS # DS
      # citra # 3DS
      dolphin-emu-beta # Wii/GameCube
      cemu # Wii U
      ryujinx # Switch

      # Remote play
      sunshine # Host
      moonlight-qt # Client

      # Steam tools
      steam-run
      steam-rom-manager

      # Proton tools
      protonup
      proton-caller

      # In-game hardware monitor
      mangohud

      vulkan-headers
    ];

    # Enable Steam
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            keyutils
            libkrb5
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
          ];

      };

      remotePlay.openFirewall = true;
      extest.enable = true;
      platformOptimizations.enable = true;
      gamescopeSession.enable = true;
    };

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    # Fixes some broken games
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ libva ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };

    # Hardware management
    programs.corectrl = {
      enable = true;

      gpuOverclock = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
    };

    users.users."${config.pear.user.name}" = {
      extraGroups = [ "corectrl" ];
    };

    # Enable gamemode
    programs.gamemode = {
      enable = true;

      settings = {
        general = {
          softrealtime = "auto";
          renice = 15;
        };

        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          amd_performance_level = "high";
        };

        custom = {
          start = "${lib.getExe pkgs.libnotify} 'GameMode started'";
          end = "${lib.getExe pkgs.libnotify} 'GameMode ended'";
        };
      };
    };

    programs.alvr = {
      enable = true;
      openFirewall = true;
    };

    # Enable bluetooth xbox controller support
    hardware.xpadneo.enable = true;

    # Add GameCube controller support
    services.udev.packages = [ pkgs.dolphin-emu-beta ];
  };
}
