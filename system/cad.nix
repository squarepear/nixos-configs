{ config, lib, pkgs, ... }:

{
  my.home.packages = with pkgs; lib.mkIf config.pear.desktop.enable [
    kicad # Electronics
    freecad # 3D Design
    openscad # 3D Design
    orca-slicer # 3D Printing
  ];
}
