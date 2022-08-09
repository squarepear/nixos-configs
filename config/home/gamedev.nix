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

  home.packages = with pkgs; [
    godot
    aseprite-unfree
  ];
}
