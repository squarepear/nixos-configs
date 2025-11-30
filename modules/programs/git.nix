{
  config,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.programs.git;
  userOptions = {
    options = {
      name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      email = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      signingKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };
in
{
  options.pear.programs.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "minimal";
    };

    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userOptions);
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (
      name:
      let
        gitIdentity = cfg.users.${name};
      in
      {
        programs.git = {
          enable = true;
          lfs.enable = true;

          signing = lib.mkIf (gitIdentity.signingKey != null) {
            signByDefault = true;
            key = gitIdentity.signingKey;
          };

          settings = {
            init.defaultBranch = "main";
            http.postBuffer = "524288000";

            user = lib.mkIf ((gitIdentity.name or null) != null || (gitIdentity.email or null) != null) {
              name = gitIdentity.name;
              email = gitIdentity.email;
            };
          };
        };

        programs.gh = {
          enable = true;
          gitCredentialHelper.enable = true;
        };
      }
    );
  };
}
