{
  config,
  inputs,
  lib,
  ...
}:

let
  cfg = config.pear.services.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.pear.services.impermanence = {
    enable = lib.mkEnableOption "impermanence service";
  };

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
      ];
      files = [
        "/etc/machine-id"
      ];
    };

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
