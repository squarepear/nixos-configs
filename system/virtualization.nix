{ config, pkgs, ... }:

{
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
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
      swtpm.enable = true;

      verbatimConfig = ''
        user = "${config.pear.user.name}"
        group = "users"
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    libguestfs
  ];

  programs.dconf.enable = true; # Needed for saving settings in virt-manager

  # Add libvirtd and tss group
  users.users."${config.pear.user.name}".extraGroups = [ "libvirtd" "kvm" "tss" ];

  # Boot configuration
  boot.kernelParams = [ "amd_iommu=on" "iommu=pt" "video=efifb:off" ];
  boot.kernelModules = [ "kvm-amd" ];
}
