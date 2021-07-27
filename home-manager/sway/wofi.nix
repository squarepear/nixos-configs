{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.wofi;

    # colors = {
    #   window = {
    #     background = "argb:583a4c54";
    #     border = "argb:582a373e";
    #     separator = "#c3c6c8";
    #   };

    #   rows = {
    #     normal = {
    #       background = "argb:58455a64";
    #       foreground = "#fafbfc";
    #       backgroundAlt = "argb:58455a64";
    #       highlight = {
    #         background = "#00bcd4";
    #         foreground = "#fafbfc";
    #       };
    #     };
    #   };
    # };
  };
} 
