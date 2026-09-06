{
  config,
  lib,
  ...
}:

let
  cfg = config.pear.desktop;
  displays = config.pear.desktop.displays;
  primaryCount = lib.count (d: d.primary) displays;
in
{
  options.pear.desktop.displays = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          output = lib.mkOption {
            type = lib.types.str;
            description = "The name of the display output (e.g., DP-1, HDMI-A-1).";
          };

          width = lib.mkOption {
            type = lib.types.int;
            description = "The width of the display resolution.";
          };

          height = lib.mkOption {
            type = lib.types.int;
            description = "The height of the display resolution.";
          };

          refreshRate = lib.mkOption {
            type = lib.types.float;
            default = 60.0;
            description = "The refresh rate of the display in Hz.";
          };

          x = lib.mkOption {
            type = lib.types.int;
            default = 0;
            description = "The X position of the display.";
          };

          y = lib.mkOption {
            type = lib.types.int;
            default = 0;
            description = "The Y position of the display.";
          };

          scale = lib.mkOption {
            type = lib.types.float;
            default = 1.0;
            description = "The scale factor for the display.";
          };

          rotation = lib.mkOption {
            type = lib.types.enum [
              0
              90
              180
              270
            ];
            default = 0;
            description = "The rotation of the display.";
          };

          primary = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Marks this output as the primary display. At most one display may set this to true.";
          };
        };
      }
    );
    default = [ ];
    description = "List of display configurations.";
  };

  config.assertions = lib.mkIf cfg.enable [
    {
      assertion = primaryCount == 1;
      message = "pear.desktop.displays: exactly one display may have primary = true (got ${toString primaryCount}).";
    }
  ];
}
