{ config, pkgs, ... }:

{
  # Enable libvirtd and virt-manager
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      vhostUserPackages = with pkgs; [ virtiofsd ];
      # Enable OpenGL and GPU acceleration
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };
  programs.virt-manager.enable = true;

  # Add libvirtd and tss group
  users.users."${config.pear.user.name}".extraGroups = [
    "libvirtd"
    "kvm"
    "tss"
  ];

  # Boot configuration
  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
    "video=efifb:off"
  ];
  boot.kernelModules = [
    "kvm-amd"
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
    "vfio_virqfd"
  ];

}
