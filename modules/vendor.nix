{ config, lib, ... }:

with lib;

let
  cfg = config.pear.vendor;
in
{
  options.pear.vendor = {
    cpu = mkOption {
      type = types.enum [
        "intel"
        "amd"
        "other"
      ];
    };

    gpu = mkOption {
      type = types.enum [
        "amd"
        "nvidia"
        "intel"
        "other"
      ];
    };
  };

  config = {
    boot.initrd.kernelModules = mkIf (cfg.gpu == "amd") [ "amdgpu" ];

    nixpkgs.config.rocmSupport = mkIf (cfg.gpu == "amd") true;
    nixpkgs.config.cudaSupport = mkIf (cfg.gpu == "nvidia") true;
  };
}
