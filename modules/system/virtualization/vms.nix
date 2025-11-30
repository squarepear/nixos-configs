{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.system.virtualization.vms;
  vendor = config.pear.system.vendor;
in
{
  options.pear.system.virtualization.vms = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.anyProfileEnabled [
        "server"
        "development"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable libvirtd and virt-manager
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        vhostUserPackages = with pkgs; [ virtiofsd ];
        # Enable OpenGL and GPU acceleration
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
      };
    };

    programs.virt-manager.enable = config.pear.desktop.enable;

    boot.kernelParams = [
      "iommu=pt"
      "video=efifb:off"
    ]
    ++ lib.optionals (vendor.gpu == "amd") [ "amd_iommu=on" ];
    boot.kernelModules = [
      "vfio"
      "vfio_iommu_type1"
      "vfio_pci"
      "vfio_virqfd"
    ]
    ++ lib.optionals (vendor.cpu == "amd") [ "kvm_amd" ];

    pear.users.adminGroups = [
      "libvirtd"
      "kvm"
    ];
  };
}
