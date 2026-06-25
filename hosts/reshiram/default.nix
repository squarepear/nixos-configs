{ pkgs, unstable, ... }:

{
  imports = [
    ./config.nix
    ./hardware-configuration.nix
    ./disks.nix
  ];

  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-MSI_M470_1TB_511210708115000680";
  # disko.devices.disk.extra.device = "/dev/disk/by-id/nvme-SKHynix_HFS001TEM4X182N_5ME9N008011209N0Z";

  boot = {
    kernelPackages = unstable.linuxKernel.packages.linux_zen;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "resume_offset=533760" ];
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  networking.hostName = "reshiram";

  # Enable 4k240hz for primary display
  hardware.display =
    let
      name = "edid-samsung-g80sd.bin";
      value = ''
        AP///////wBMLTXgAAAAAAEiAQS1Rid4OzSVr046uyUMUFQlzwBxT4HAgQCBgJUAqcCzANHATdAA
        oPBwPoAwIDUAwBwyAAAaAAAA/Qww8P//6gEKICAgICAgAAAA/ABPZHlzc2V5IEc4MFNEAAAAEAAA
        AAAAAAAAAAAAAAAAA2kCAzpAR2FfED8EA3YjCQcHgwEAAOMFwwDmBgUBYEsD5QGLhJABdBoAAAMH
        MPAAoGACSwLwAAAAAAAAVl4AoKCgKVAwIDUAgGghAAAab8IAoKCgVVAwIDUAgGghAAAaAjqAGHE4
        LUBYLEUA4A4RAAAeAAAAAAAAAAAAAAAAAAAARXAgeQAAKgASAf8ObwjvAf8JnwXvAX8HNwTvAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGqQcCB5AAAiABS/lCMA/w6f
        AC+AHwBvCAwBAgAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAt5A=
      '';
    in
    {
      edid.enable = true;
      edid.packages = [
        (pkgs.runCommand name { } ''
          mkdir -p "$out/lib/firmware/edid"
          base64 -d > "$out/lib/firmware/edid/${name}" <<'EOF'
          ${value}
          EOF
        '')
      ];
      outputs.DP-2.edid = name;
    };
}
