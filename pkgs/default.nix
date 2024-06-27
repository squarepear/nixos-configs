{ ... }:

let
  overlay = self: super: {
    apple-color-emoji = super.callPackage ./apple-color-emoji.nix { };
    # freecad-git = super.callPackage (import ./freecad-git.nix self super) { };
    pokedex = super.callPackage ./pokedex.nix { };
  };
in
{
  nixpkgs.overlays = [ overlay ];
}
