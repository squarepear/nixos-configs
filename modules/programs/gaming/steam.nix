{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  gamingCfg = config.pear.programs.gaming;
  cfg = gamingCfg.steam;
in
{
  options.pear.programs.gaming.steam = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = gamingCfg.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    programs.steam = {
      enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];

      remotePlay.openFirewall = true;
      extest.enable = true;

      gamescopeSession.enable = true;
    };

    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".local/share/Steam"
      ];
    });
  };
}
