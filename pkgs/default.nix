{ ... }:

let
  overlay = self: super: {
    apple-color-emoji = super.callPackage ./apple-color-emoji.nix { };
    bibata-hyprcursor = super.callPackage ./bibata-hyprcursor.nix { };
    # freecad-git = super.callPackage (import ./freecad-git.nix self super) { };
    pokedex = super.callPackage ./pokedex.nix { };
    wivrn-local = super.callPackage ./wivrn.nix { };
  };
in
{
  nixpkgs.overlays = [ overlay ];
}
