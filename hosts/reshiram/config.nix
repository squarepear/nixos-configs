{ ... }:
{
  pear = {
    services.ai.enable = true;
    programs.obs.enable = true;

    system.secureboot.enable = true;
    system.impermanence.enable = true;

    system.vendor.cpu = "amd";
    system.vendor.gpu = "amd";

    system.core.flakePath = "/home/jeffrey/Projects/nixos-configs";

    system.profiles = [
      "desktop"
      "gaming"
      "development"
    ];
  };
}
