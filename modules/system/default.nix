{ ... }:

{
  imports = [
    ./networking
    ./profiles
    ./virtualization

    ./bluetooth.nix
    ./audio.nix
    ./core.nix
    ./fonts.nix
    ./impermanence.nix
    ./printing.nix
    ./secrets.nix
    ./secureboot.nix
    ./vendor.nix
  ];
}
