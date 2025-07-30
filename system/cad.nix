{ config, lib, pkgs, ... }:

{
  my.home.packages = with pkgs; lib.mkIf config.pear.desktop.enable [
    kicad # Electronics
    freecad-wayland # 3D Design
    openscad # 3D Design
    # FIXME: Waiting on https://github.com/NixOS/nixpkgs/issues/429433
    # orca-slicer # 3D Printing
  ];
}
