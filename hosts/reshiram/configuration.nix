# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      /home/jeffrey/nixos-configs/nixos/users/jeffrey.nix

      /home/jeffrey/nixos-configs/nixos
      /home/jeffrey/nixos-configs/nixos/pkgs/rgb.nix
      /home/jeffrey/nixos-configs/nixos/pkgs/virtualization.nix
      /home/jeffrey/nixos-configs/home-manager
    ];

  # Enables CPU microcode updates
  hardware.cpu.amd.updateMicrocode = true;

  # Linux Kernel Version
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/Indiana/Indianapolis";

  # Define your hostname.
  networking.hostName = "reshiram";
  networking.networkmanager.enable = true;
  networking.firewall.trustedInterfaces = [ "eno1" "wlp5s0" ];

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    wirelesstools
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    zenpower # AMD Zen CPU monitoring
  ];

  boot.blacklistedKernelModules = [
    "k10temp" # Disable generic monitoring
  ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # GPU setup
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable sound.
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
  hardware.pulseaudio.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    brlaser
    gutenprint
  ];

  # For network discovery of printers
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # reshiram.local
  services.avahi.publish.enable = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.workstation = true;

  # USB auto-mount
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
