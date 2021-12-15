{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${fetchTarball "https://github.com/NixOS/nixos-hardware/archive/7da029f26849f8696ac49652312c9171bf9eb170.tar.gz" }/raspberry-pi/4"

      /home/jeffrey/nixos-configs/nixos/users/jeffrey.nix

      /home/jeffrey/nixos-configs/nixos/base.nix
      /home/jeffrey/nixos-configs/nixos/pkgs
      /home/jeffrey/nixos-configs/nixos/pkgs/k3s/server.nix

      /home/jeffrey/nixos-configs/home-manager/base.nix
    ];

  # import home-manager packages
  home-manager.users.jeffrey = { ... }: {
    imports = [
      /home/jeffrey/nixos-configs/home-manager/pkgs
    ];
  };

  # Set your time zone.
  time.timeZone = "America/Indiana/Indianapolis";

  # Define your hostname.
  networking.hostName = "tepig";
  networking.networkmanager.enable = true;
  networking.firewall.trustedInterfaces = [ "eth0" "wlan0" ];

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    wirelesstools
  ];

  # Enable NFS Server
  services.nfs.server = {
    enable = true;

    exports = ''
      /cluster-nfs 100.0.0.0/8(rw,sync,no_root_squash,insecure)
    '';
  };
  networking.firewall.allowedTCPPorts = [ 2049 ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # tepig.local
  services.avahi.publish.enable = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.workstation = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

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

