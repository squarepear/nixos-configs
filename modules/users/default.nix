{ config, lib, ... }:

let
  cfg = config.pear.users;

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
  options.pear.users = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
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
      # TODO: REMOVE THIS DEFAULT PASSWORD!
      password = "disko";
      # hashedPasswordFile = config.age.secrets.${ageName name}.path;
      home = "/home/${name}";
      openssh.authorizedKeys.keys = userCfg.publicKeys;
    }) cfg.users;

    age.secrets = lib.mapAttrs' (
      name: userCfg: lib.nameValuePair (ageName name) ({ file = userCfg.hashedPasswordAgeFile; })
    ) cfg.users;

    # Service that creates home directories for users if they do not exist yet
    # Needed because users.users.createHome happens too early in the boot process
    # and fails when /home is on a separate filesystem
    # Can remove once https://github.com/NixOS/nixpkgs/issues/6481 is resolved
    systemd.services.create-user-homes = {
      description = "Create home directories for users";
      after = [ "local-fs.target" ];
      before = [ "systemd-user-sessions.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        set -euo pipefail

        ${lib.concatMapStringsSep "\n" (name: ''
          HOME_DIR="/home/${name}"
          if [ ! -d "$HOME_DIR" ]; then
            echo "Creating home directory for user ${name}"
            mkdir -p "$HOME_DIR"
            chown ${name}:users "$HOME_DIR"
            chmod 700 "$HOME_DIR"
            echo "Successfully created home directory for ${name}"
          else
            echo "Home directory for ${name} already exists"
          fi
        '') (lib.attrNames cfg.users)}
      '';
    };

    # Trust all admin users for nix commands
    nix.settings.trusted-users = lib.attrNames (
      lib.filterAttrs (name: userCfg: userCfg.isAdmin) cfg.users
    );
  };
}
