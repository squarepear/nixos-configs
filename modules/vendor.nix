{ config, lib, ... }:

let
  cfg = config.pear.vendor;
in
{
  options.pear.vendor = {
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

  config = {
    boot.initrd.kernelModules = lib.mkIf (cfg.gpu == "amd") [ "amdgpu" ];

    nixpkgs.config.rocmSupport = lib.mkIf (cfg.gpu == "amd") true;
    nixpkgs.config.cudaSupport = lib.mkIf (cfg.gpu == "nvidia") true;
  };
}
