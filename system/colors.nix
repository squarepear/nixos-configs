{ inputs, ... }:

{
  my = {
    imports = [
      inputs.nix-colors.homeManagerModule
    ];

    # colorScheme = inputs.nix-colors.colorSchemes.ayu-dark;
    # colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
    # colorScheme = inputs.nix-colors.colorSchemes.circus; # +
    # colorScheme = inputs.nix-colors.colorSchemes.classic-dark;
    colorScheme = inputs.nix-colors.colorSchemes.evenok-dark; # +, OLED black
    # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-material-dark-hard;
    # colorScheme = inputs.nix-colors.colorSchemes.kanagawa; # +
    # colorScheme = inputs.nix-colors.colorSchemes.material-darker; # +
  };
}
