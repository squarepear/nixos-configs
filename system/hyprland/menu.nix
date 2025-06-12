{ config, lib, pkgs, ... }:

let
  inherit (config.my.colorScheme) palette;
in
{
  config = lib.mkIf (config.pear.desktop.wm == "hyprland") {
    my.programs = {
      tofi = {
        enable = true;

        settings = {
          # Optimizations
          font = "${pkgs.nerd-fonts.caskaydia-cove}/share/fonts/truetype/NerdFonts/CaskaydiaCove/CaskaydiaCoveNerdFontMono-Regular.ttf";
          hint-font = false;
          ascii-input = true;

          # Menu settings
          width = "100%";
          height = "100%";
          border-width = 0;
          outline-width = 0;
          padding-left = "35%";
          padding-top = "35%";
          result-spacing = 25;
          num-results = 5;
          background-color = "#000A";
        };
      };
    };
  };
}
