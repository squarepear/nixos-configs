{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.programs.social.discord;
in
{
  options.pear.programs.social.discord = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.allProfilesEnabled [
        "desktop"
        "gaming"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (name: {
      home.packages = with pkgs; [
        discord-canary
      ];
    });

    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".config/discord"
        ".config/discordcanary/"
      ];
    });
  };
}
