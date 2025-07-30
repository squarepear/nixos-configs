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
    lmms
    # FIXME: Waiting on https://github.com/NixOS/nixpkgs/pull/429334
    # audacity

    # Note Taking and Planning
    obsidian
  ];
}
