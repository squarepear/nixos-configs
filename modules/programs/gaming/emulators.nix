{
  config,
  lib,
  pearlib,
  unstable,
  ...
}:

let
  gamingCfg = config.pear.programs.gaming;
  cfg = gamingCfg.emulators;
in
{
  options.pear.programs.gaming.emulators = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = gamingCfg.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (name: {
      home.packages = with unstable; [
        sameboy # GB/GBC
        mgba # GBA
        melonds # DS
        # ... # 3DS
        dolphin-emu # Wii/GameCube
        cemu # Wii U
        # ... # Switch
      ];
    });

    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".config/sameboy" # GB/GBC saves and settings
        ".config/mgba" # GBA saves and settings
        ".config/melonDS" # DS saves and settings
        ".local/share/dolphin-emu" # Wii/GameCube saves and settings
        ".local/share/Cemu" # Wii U saves and settings
      ];
    });
  };
}
