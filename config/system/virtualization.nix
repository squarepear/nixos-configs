{ config, pkgs, ... }:

{
  # Boot configuration
  boot.kernelParams = [
    # Enable IOMMU
    "amd_iommu=on"
    "iommu=pt"
  ];

  # Enable libvirtd
  virtualisation.libvirtd = {
    enable = true;
    extraConfig = ''
      unix_sock_group = "libvirtd"
      unix_sock_rw_perms = "0770"
      log_filters="1:qemu"
      log_outputs="1:file:/var/log/libvirt/libvirtd.log"
    '';

    onBoot = "ignore";
    onShutdown = "shutdown";

    qemu = {
      ovmf.enable = true;

      verbatimConfig = ''
        user = "jeffrey"
        users = "users"
      '';
    };
  };

  # Add libvirtd group
  users.users.jeffrey = {
    extraGroups = [ "libvirtd" ];
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    libguestfs
  ];

  programs.dconf.enable = true; # Needed for saving settings in virt-manager
}
