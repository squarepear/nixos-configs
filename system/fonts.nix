{ pkgs, ... }:

{
  my.fonts.fontconfig.enable = true;

  my.home.packages = with pkgs; [
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.caskaydia-cove
    apple-color-emoji
  ];
}
