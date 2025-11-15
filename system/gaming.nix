{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

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
      dolphin-emu # Wii/GameCube
      cemu # Wii U
      # torzu_git # Switch

      # Remote play
      moonlight-qt # Client

      # Steam tools
      steam-run
      steam-rom-manager

      # Proton tools
      protonup-ng

      # In-game hardware monitor
      mangohud

      # VR tools
      sidequest
      bs-manager

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

      env = {
        DXVK_HDR = "1";
      };

      args = [
        "--rt"
        "--hdr-enabled"
        "--hdr-itm-enabled"
        "--hdr-debug-force-output"
        "--xwayland-count 2"
        "-W 3840"
        "-H 2160"
        "-r 240"
      ];
    };

    # Sunshine settings
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    # HDR settings
    chaotic.mesa-git.enable = true;
    chaotic.mesa-git.fallbackSpecialisation = false;
    chaotic.hdr.enable = true;
    chaotic.hdr.specialisation.enable = false;

    # Fixes some broken games
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva
        monado-vulkan-layers
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };

    # Hardware management
    hardware.amdgpu.overdrive.enable = true;
    services.lact.enable = true;

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

    # https://github.com/CachyOS/ananicy-rules
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos_git;
    };

    # programs.alvr = {
    #   enable = true;
    #   openFirewall = true;
    # };

    programs.ns-usbloader.enable = true;

    services.wivrn = {
      enable = true;

      package = pkgs.wivrn;

      autoStart = true;
      openFirewall = true;
      highPriority = true;
      defaultRuntime = true;
      steam.importOXRRuntimes = true;

      config = {
        enable = true;

        json = {
          bitrate = 135000000;
          # application = pkgs.wlx-overlay-s;
        };
      };
    };

    programs.adb.enable = true;

    services.desktopManager.gnome.sessionPath = [ pkgs.sidequest ];

    # Enable bluetooth xbox controller support
    # hardware.xpadneo.enable = true;

    # Add more controller support
    hardware.uinput.enable = true;
    services.udev.packages = [
      pkgs.dolphin-emu
      pkgs.game-devices-udev-rules
    ];
    hardware.steam-hardware.enable = true;
  };
}
