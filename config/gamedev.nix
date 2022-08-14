{ pkgs, ... }:

{
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     godot = prev.godot.overrideAttrs (_: {
  #       version = 
  #       src = final.fetchFromGitHub
  #         {

  #         };
  #     });
  #   })
  # ];

  my.home.packages = with pkgs; [
    godot
    aseprite-unfree
  ];
}
