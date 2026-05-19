{
  config,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.programs.tmux;
in
{
  options.pear.programs.tmux = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "minimal";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      programs.tmux = {
        enable = true;
      };
    });
  };
}
