{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pear.programs.zsh;
in
{
  options.pear.programs.zsh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    isDefaultShell = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;
    programs.starship.enable = true;

    users.defaultUserShell = lib.mkIf cfg.isDefaultShell pkgs.zsh;
  };
}
