{ ... }:

{
  pear = {
    programs.librepods.enable = true;
    programs.obs.enable = true;

    system.secureboot.enable = true;
    system.impermanence.enable = true;

    system.vendor.cpu = "amd";
    system.vendor.gpu = "amd";

    desktop = {
      environment = "niri";

      displays = [
        {
          output = "DP-3";
          width = 3840;
          height = 2160;
          refreshRate = 60.0;
          x = 0;
          y = 432;
        }
        {
          output = "DP-2";
          width = 3840;
          height = 2160;
          refreshRate = 240.0;
          x = 3840;
          y = 0;
          primary = true;
        }
      ];
    };

    system.core.flakePath = "/home/jeffrey/Projects/nixos-configs";

    system.profiles = [
      "desktop"
      "gaming"
      "development"
    ];
  };
}
