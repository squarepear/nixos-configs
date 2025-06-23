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
    gimp3

    # Audio
    # lmms # FIXME: Waiting for https://github.com/NixOS/nixpkgs/pull/418925
    audacity

    # Note Taking and Planning
    obsidian
  ];
}
