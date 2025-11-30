{ config, lib, ... }:

let
  cfg = config.pear.system.vendor;
in
{
  options.pear.system.vendor = {
    cpu = lib.mkOption {
      type = lib.types.enum [
        "intel"
        "amd"
        "arm"
        "undefined"
      ];
      default = "undefined";
    };

    gpu = lib.mkOption {
      type = lib.types.enum [
        "amd"
        "nvidia"
        "intel"
        "undefined"
      ];
      default = "undefined";
    };
  };

  config = lib.mkMerge [
    {
      boot.initrd.kernelModules = lib.mkIf (cfg.gpu == "amd") [ "amdgpu" ];

      nixpkgs.config.rocmSupport = lib.mkIf (cfg.gpu == "amd") true;
      nixpkgs.config.cudaSupport = lib.mkIf (cfg.gpu == "nvidia") true;
    }

    # AMD Zen CPU monitoring
    (lib.mkIf (cfg.cpu == "amd") {
      boot.kernelModules = [ "zenpower" ];
      boot.extraModulePackages = with config.boot.kernelPackages; [
        zenpower
      ];

      # Disable generic monitoring
      boot.blacklistedKernelModules = [
        "k10temp"
      ];
    })
  ];
}
