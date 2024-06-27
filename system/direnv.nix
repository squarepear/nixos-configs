{ config, ... }:

{
  my.programs.direnv = {
    enable = true;
    enableZshIntegration = config.my.programs.zsh.enable;

    nix-direnv.enable = true;
  };

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 1048576; # Fixes watch limit issues
  };
}
