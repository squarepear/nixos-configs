{ inputs, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./hardware-configuration.nix

    ../../system/ai.nix
    ../../system/audio.nix
    ../../system/backup.nix
    ../../system/bat.nix
    ../../system/bluetooth.nix
    ../../system/cad.nix
    ../../system/containers.nix
    ../../system/direnv.nix
    ../../system/firefox.nix
    ../../system/fonts.nix
    ../../system/gamedev.nix
    ../../system/gaming.nix
    ../../system/git.nix
    ../../system/keyboard.nix
    ../../system/hyprland
    ../../system/k3s/manager.nix
    ../../system/kitty.nix
    ../../system/music.nix
    ../../system/neovim
    ../../system/networking.nix
    ../../system/nfs.nix
    ../../system/obs.nix
    ../../system/printing.nix
    # ../../system/rgb.nix
    ../../system/secrets.nix
    ../../system/ssh.nix
    ../../system/tailscale.nix
    ../../system/usb.nix
    ../../system/virtualization.nix
    ../../system/vscode.nix
    # ../../system/waydroid.nix
    ../../system/zenpower.nix
    ../../system/zsh.nix

    ../../users/jeffrey.nix
  ];

  # System hostname
  networking.hostName = "reshiram";

  # Boot Settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.memtest86.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  # services.scx.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [ liquidctl ];
  programs.droidcam.enable = true;

  # Automatically trim unused space from the filesystem
  services.fstrim.enable = true;

  # Enable building for aarch64 (Raspberry Pi)
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  services.usbmuxd.enable = true;

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

  console = {
    font = mkForce "ter-i32b";
    packages = [ pkgs.terminus_font ];
  };

  pear = {
    desktop = {
      enable = true;
      wm = "hyprland";
    };

    vendor = {
      cpu = "amd";
      gpu = "amd";
    };
  };
}
