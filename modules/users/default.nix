{
  config,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.users;

  isFreshInstall = config.pear.isFreshInstall;

  ageName = name: "user-${name}-password";

  userOptions = {
    options = {
      isAdmin = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      hashedPasswordAgeFile = lib.mkOption {
        type = lib.types.path;
      };

      publicKeys = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        # If you are referencing my configs, make sure to replace this with your own SSH public key(s)!
        default = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyZWg5m3pXHOqNfdrO6ecghFfQowb/Y7Df7otocETHq" ];
      };
    };
  };
in
{
  imports = [
    ./home-manager
  ];

  options.pear.users = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "minimal";
    };

    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userOptions);
    };

    defaultGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    adminGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    users.mutableUsers = false;

    users.users = lib.mapAttrs (name: userCfg: {
      name = name;
      isNormalUser = true;
      group = "users";
      extraGroups = cfg.defaultGroups ++ lib.optionals userCfg.isAdmin ([ "wheel" ] ++ cfg.adminGroups);
      useDefaultShell = true;
      password = lib.mkIf isFreshInstall "password";
      hashedPasswordFile = lib.mkIf (
        !isFreshInstall && userCfg.hashedPasswordAgeFile != null
      ) config.age.secrets.${ageName name}.path;
      home = "/home/${name}";
      openssh.authorizedKeys.keys = userCfg.publicKeys;
    }) cfg.users;

    age.secrets = lib.mkIf (!isFreshInstall) (
      lib.mapAttrs' (
        name: userCfg: lib.nameValuePair (ageName name) ({ file = userCfg.hashedPasswordAgeFile; })
      ) cfg.users
    );

    # Trust all admin users for nix commands
    nix.settings.trusted-users = pearlib.admins;
  };
}
