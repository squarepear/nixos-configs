{ pkgs, ... }:

{
  imports = [
    ./config.nix
    ./hardware-configuration.nix
    ./disks.nix
  ];

  disko.devices.disk.main.device = "/dev/nvme0n1";
  # disko.devices.disk.extra.device = "/dev/nvme1n1";

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "resume_offset=533760" ];
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  networking.hostName = "reshiram"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "America/Indianapolis";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

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
