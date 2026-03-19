# This disko config documents the intended disk layout for reinstallation.
# Mountpoints are intentionally omitted so disko does not generate fileSystems
# entries — the existing disk uses MBR partitioning (Raspberry Pi 4 requirement)
# so GPT partlabels cannot be set. See hardware-configuration.nix for the
# actual mount definitions.
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
              content = {
                type = "filesystem";
                format = "vfat";
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
                  "@" = { };
                  "@nix" = { };
                  "@var" = { };
                  "@boot" = { };
                  "@home" = { };
                };
              };
            };
          };
        };
      };
    };
  };
}
