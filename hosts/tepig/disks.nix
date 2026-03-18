{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/ata-Samsung_Portable_SSD_T5_S49XNV0KA12069D";
        content = {
          type = "gpt";
          partitions = {
            firmware = {
              label = "FIRMWARE";
              size = "512M";
              # Plain FAT partition for Raspberry Pi 4 firmware — not an EFI system partition.
              # The nixos-hardware raspberry-pi-4 module mounts this at /boot/firmware.
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/firmware";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  "NIXOS_SD"
                  "-f"
                ];
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@var" = {
                    mountpoint = "/var";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@boot" = {
                    mountpoint = "/boot";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
