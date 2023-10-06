{ pkgs, ... }:

{
  my.home.packages = with pkgs; [
    godot_4
    aseprite-unfree
    blender-hip
    notion-app-enhanced
    logseq
  ];
}
