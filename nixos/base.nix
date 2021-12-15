{ pkgs, ... }:

{
  # Remove duplicate files in nix store
  nix.autoOptimiseStore = true;

  # Allow unfree packages (vscode, steam, ...)
  nixpkgs.config.allowUnfree = true;
}
