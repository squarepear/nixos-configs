{ config, ... }:

{
  # AMD Zen CPU monitoring
  boot.extraModulePackages = with config.boot.kernelPackages; [
    zenpower
  ];

  # Disable generic monitoring
  boot.blacklistedKernelModules = [
    "k10temp"
  ];
}
