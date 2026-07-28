{
  config,
  inputs,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.programs.ai.crush;
  crushPkg = inputs.nix-ai-tools.packages.${config.nixpkgs.hostPlatform.system}.crush;
in
{
  options.pear.programs.ai.crush = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "desktop";
      description = "Enable Crush for all users.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      home.packages = [ crushPkg ];

      home.sessionVariables = {
        CRUSH_GLOBAL_CONFIG = "$HOME/.config/crush";
        CRUSH_GLOBAL_DATA = "$HOME/.local/share/crush";
      };
    });

    pear.system.impermanence.users = pearlib.perUser (_: {
      persist.directories = [
        ".config/crush"
        ".local/share/crush"
      ];
    });
  };
}
