{ inputs, ... }:

{
  my = {
    imports = [
      inputs.nix-colors.homeManagerModule
    ];

    colorScheme = inputs.nix-colors.colorSchemes.equilibrium-dark;
    # colorScheme = inputs.nix-colors.colorSchemes.tender;

  };
}
