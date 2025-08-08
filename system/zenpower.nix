{ config, ... }:

{
  # AMD Zen CPU monitoring
  boot.kernelModules = [ "zenpower" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    zenpower
  ];

  # Disable generic monitoring
  boot.blacklistedKernelModules = [
    "k10temp"
  ];
}
