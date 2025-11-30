{
  config,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.programs.direnv;
in
{
  options.pear.programs.direnv = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "development";
      description = "Enable direnv + nix-direnv for all users.";
    };

    enableZshIntegration = lib.mkOption {
      type = lib.types.bool;
      default = config.pear.programs.zsh.enable;
      description = "Whether to enable zsh integration for direnv.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      programs.direnv = {
        enable = true;
        enableZshIntegration = cfg.enableZshIntegration;
        nix-direnv.enable = true;
      };
    });

    boot.kernel.sysctl."fs.inotify.max_user_watches" = 1048576; # Fixes watch limit issues

    pear.system.impermanence.users = pearlib.perUser (_: {
      persist.directories = [
        ".local/share/direnv"
      ];
    });
  };
}
