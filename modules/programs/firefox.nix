{
  config,
  lib,
  pearlib,
  unstable,
  ...
}:

let
  cfg = config.pear.programs.firefox;
in
{
  options.pear.programs.firefox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "desktop";
      description = "Enable Firefox for all users (home-manager).";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      programs.firefox.enable = true;
      programs.firefox.package = unstable.firefox;
    });

    pear.system.impermanence.users = pearlib.perUser (_: {
      persist.directories = [
        ".mozilla"
      ];
    });
  };
}
