{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      /home/jeffrey/nixos-configs/nixos/users/jeffrey.nix

      /home/jeffrey/nixos-configs/nixos/base.nix
      /home/jeffrey/nixos-configs/nixos/pkgs
      /home/jeffrey/nixos-configs/nixos/pkgs/docker.nix

      /home/jeffrey/nixos-configs/home-manager/base.nix
    ];

  # import home-manager packages
  home-manager.users.jeffrey = { ... }: {
    imports = [
      /home/jeffrey/nixos-configs/home-manager/pkgs
    ];
  };

  # Linux Kernel Version
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/Indiana/Indianapolis";

  # Define your hostname.
  networking.hostName = "shuckle";
  networking.networkmanager.enable = true;
  networking.firewall.trustedInterfaces = [ "enp2s5" ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s5.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Fix issue with GPU
  boot.kernelParams = [ "nomodeset" ];

  # Enable sound.
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
  hardware.pulseaudio.enable = false;

  # shuckle.local
  services.avahi.publish.enable = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.workstation = true;

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

