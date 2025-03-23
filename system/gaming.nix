{ config, inputs, lib, pkgs, ... }:

{
  imports = [
    inputs.chaotic.nixosModules.default
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
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
      # lime3ds # 3DS
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

      # VR tools
      sidequest

      vulkan-headers
    ];

    # Enable Steam
    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [
        gamescope
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
      extraCompatPackages = [
        pkgs.proton-ge-custom
      ];

      remotePlay.openFirewall = true;
      extest.enable = true;
      platformOptimizations.enable = true;
    };

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    programs.steam.gamescopeSession = {
      enable = true;

      args = [
        "--rt"
        "--hdr-enabled"
        "--hdr-itm-enable"
        "--xwayland-count 2"
        "-W 3840"
        "-H 2160"
        "-r 240"
      ];
    };

    chaotic.mesa-git.enable = true;
    chaotic.hdr.enable = true;

    # Fixes some broken games
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ libva monado-vulkan-layers ];
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

    # programs.alvr = {
    #   enable = true;
    #   openFirewall = true;
    # };

    programs.ns-usbloader.enable = true;

    services.wivrn = {
      enable = true;

      package = pkgs.wivrn-local.override {
        opencomposite = inputs.nixpkgs-xr.packages.${pkgs.stdenv.hostPlatform.system}.opencomposite;
      };

      autoStart = true;
      openFirewall = true;
      defaultRuntime = true;

      extraPackages = [ pkgs.wayvr-dashboard ];

      config = {
        enable = true;

        json = {
          bitrate = 135000000;
          application = pkgs.wlx-overlay-s;
        };
      };
    };

    services.xserver.desktopManager.gnome.sessionPath = [ pkgs.sidequest ];

    # Enable bluetooth xbox controller support
    # hardware.xpadneo.enable = true;

    # Add more controller support
    hardware.uinput.enable = true;
    services.udev.packages = [ pkgs.dolphin-emu-beta pkgs.game-devices-udev-rules ];
    hardware.steam-hardware.enable = true;
  };
}
