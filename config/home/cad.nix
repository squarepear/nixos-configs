{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; lib.mkIf config.system.gui.enable [
    kicad-unstable # Electronics
    freecad # 3D Design
    prusa-slicer # 3D Printer Slicer
  ];
}
