{ config, inputs, lib, pkgs, ... }:

{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  config = lib.mkIf config.system.gui.enable {
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
      # ryujinx # Switch

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

      extest.enable = true;

      remotePlay.openFirewall = true;

      gamescopeSession = {
        enable = true;
        env = {
          # Show VRR controls in Steam
          STEAM_GAMESCOPE_VRR_SUPPORTED = "1";

          # Some environment variables by default (taken from Deck session)
          SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = "0";

          # STEAM_MULTIPLE_XWAYLANDS = "1";

          # Enable Mangoapp
          STEAM_MANGOAPP_PRESETS_SUPPORTED = "1";
          STEAM_USE_MANGOAPP = "1";
          MANGOHUD_CONFIGFILE = "$(mktemp /tmp/mangohud.XXXXXXXX)";
        };
        args = [
          "-f"
          "-F fsr"
          "-w 3840"
          "-h 2160"
          "-r 120"
          "--rt"
          "--xwayland-count 2"
          "--hdr-enabled"
        ];
      };
    };

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
      SDL_JOYSTICK_HIDAPI = "0"; # Fixes incorrect controller mappings
    };

    # Fixes some broken games
    hardware.opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [ libva ];
      driSupport32Bit = true;
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

    users.users."${config.user.name}" = {
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
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
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
