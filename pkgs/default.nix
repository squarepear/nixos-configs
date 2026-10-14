{ ... }:

let
  overlay = self: super: {
    bibata-hyprcursor = super.callPackage ./bibata-hyprcursor.nix { };
    pokedex = super.callPackage ./pokedex.nix { };
    librepods = super.callPackage ./librepods.nix { };
    holo-realtek-firmware-toggles = super.callPackage ./holo-realtek-firmware-toggles.nix { };
  };
in
{
  nixpkgs.overlays = [ overlay ];
}
