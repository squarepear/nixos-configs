{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              label = "luks";
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                settings = {
                  allowDiscards = true;
                };
                extraOpenArgs = [
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-L"
                    "nixos"
                    "-f"
                  ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "40G";
                    };
                  };
                };
              };
            };
          };
        };
      };

      # extra = {
      #   type = "disk";
      #   content = {
      #     type = "gpt";
      #     partitions = {
      #       extra = {
      #         size = "100%";
      #         content = {
      #           type = "btrfs";
      #           extraArgs = [
      #             "-L"
      #             "extra"
      #             "-f"
      #           ];
      #           subvolumes = {
      #             "/mnt/games" = {
      #               mountpoint = "/mnt/games";
      #               mountOptions = [
      #                 "compress=zstd"
      #                 "noatime"
      #               ];
      #             };
      #           };
      #         };
      #       };
      #     };
      #   };
      # };
    };
  };
}
