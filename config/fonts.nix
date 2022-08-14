{ pkgs, ... }:

{
  my.fonts.fontconfig.enable = true;

  my.home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" "Ubuntu" "UbuntuMono" ]; })
  ];
}
