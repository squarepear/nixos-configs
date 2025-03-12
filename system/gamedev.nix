{ pkgs, ... }:

{
  my.home.packages = with pkgs; [
    # Game Engines
    godot_4

    # Art
    blender
    aseprite-unfree
    krita
    inkscape
    gimp

    # Audio
    lmms
    audacity

    # Note Taking and Planning
    obsidian
  ];
}
