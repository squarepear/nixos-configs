{ config, ... }:

{
  my.programs.direnv = {
    enable = true;
    enableZshIntegration = config.my.programs.zsh.enable;

    nix-direnv.enable = true;
  };
}
