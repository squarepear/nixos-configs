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

      melonDS # DS emulator
      citra # 3DS emulator
      dolphin-emu-beta # Wii/GameCube emulator
      yuzu-ea # Switch emulator

      # Steam tools
      steam-run
      steam-rom-manager
      gamescope

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

      remotePlay.openFirewall = true;
    };

    # Fixes some broken games
    hardware.opengl = {
      enable = true;
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

    # Enable gamemode
    programs.gamemode = {
      enable = true;

      settings = {
        general = {
          renice = 10;
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

    # Enable bluetooth xbox controller support
    # hardware.xpadneo.enable = true;

    # Add GameCube controller support
    services.udev.packages = [ pkgs.dolphin-emu-beta ];
  };
}
