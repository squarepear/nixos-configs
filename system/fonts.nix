{ pkgs, inputs, ... }:

{
  my.fonts.fontconfig.enable = true;

  my.home.packages = with pkgs; [
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.caskaydia-cove
    inputs.apple-emoji-linux.packages.${pkgs.stdenv.hostPlatform.system}.apple-emoji-linux
  ];
}
