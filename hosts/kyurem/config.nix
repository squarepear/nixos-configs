{ ... }:

{
  pear = {
    system.secureboot.enable = true;
    system.impermanence.enable = true;

    system.vendor.cpu = "intel";
    system.vendor.gpu = "amd";

    desktop = {
      environment = "niri";

      displays = [
        {
          output = "eDP-1";
          width = 3840;
          height = 2160;
          refreshRate = 60.0;
          x = 0;
          y = 0;
          primary = true;
        }
      ];
    };

    system.profiles = [
      "desktop"
      "gaming"
      "development"
    ];
  };
}
