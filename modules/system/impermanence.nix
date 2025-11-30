{
  config,
  inputs,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.system.impermanence;

  persistType = lib.types.submodule {
    freeformType = lib.types.attrsOf lib.types.anything;
    options = {
      directories = lib.mkOption {
        type = lib.types.listOf lib.types.anything;
        default = [ ];
        description = "Directories to persist.";
      };
      files = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Files to persist.";
      };
    };
  };

  userOptions = {
    options = {
      persist = lib.mkOption {
        type = persistType;
        default = { };
        description = "Home-manager impermanence persistence configuration for this user. Gets mapped to home.persistence.\"/persist/home/\${name}\".";
      };
    };
  };
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.pear.system.impermanence = {
    enable = lib.mkEnableOption "impermanence service";

    persist = lib.mkOption {
      type = persistType;
      default = { };
      description = "System-wide impermanence persistence configuration. Gets mapped to environment.persistence.\"/persist\".";
    };

    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userOptions);
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = lib.mkMerge [
      {
        hideMounts = true;
        directories = [
          "/etc/ssh"
          "/var/lib/bluetooth"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/etc/NetworkManager/system-connections"
        ];
        files = [
          "/etc/machine-id"
        ];
      }
      cfg.persist
    ];

    home-manager.users = pearlib.perUser (name: {
      home.persistence."/persist" = lib.mkMerge [
        {
          directories = [
            "Downloads"
            "Music"
            "Pictures"
            "Documents"
            "Development"
            "Videos"
          ];
          files = [
            ".screenrc"
          ];
        }
        cfg.users.${name}.persist
      ];
    });

    age.identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

    programs.fuse.userAllowOther = true;

    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    boot.initrd.systemd = {
      enable = true; # this enabled systemd support in stage1 - required for the below setup
      services.rollback = {
        description = "Rollback BTRFS root subvolume to a pristine state";
        wantedBy = [ "initrd.target" ];

        # LUKS/TPM process. If you have named your device mapper something other
        # than 'enc', then @enc will have a different name. Adjust accordingly.
        after = [ "systemd-cryptsetup@cryptroot.service" ];

        # Before mounting the system root (/sysroot) during the early boot process
        before = [ "sysroot.mount" ];

        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /mnt

          mount -o subvol=/ /dev/mapper/cryptroot /mnt

          if [[ -e /mnt/root ]]; then
              mkdir -p /mnt/old_roots
              timestamp=$(date --date="@$(stat -c %Y /mnt/root)" "+%Y-%m-%-d_%H:%M:%S")
              echo "Backing up existing root subvolume to /mnt/old_roots/$timestamp"
              mv /mnt/root "/mnt/old_roots/$timestamp"
          fi

          delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "/mnt/$i"
              done

              echo "Deleting subvolume $1"
              btrfs subvolume delete "$1"
          }

          for i in $(find /mnt/old_roots/ -maxdepth 1 -mtime +30); do
              delete_subvolume_recursively "$i"
          done

          echo "Creating new root subvolume at /mnt/root"
          btrfs subvolume create /mnt/root
          umount /mnt
        '';
      };
    };

    fileSystems."/persist".neededForBoot = true;
    fileSystems."/var/log".neededForBoot = true;
  };
}
