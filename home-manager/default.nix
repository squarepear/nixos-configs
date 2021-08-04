{ pkgs, ... }:

{
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  home-manager.users.jeffrey = { ... }: {
    programs.home-manager.enable = true;

    imports = [
      ./bat.nix
      ./brave.nix
      ./git.nix
      ./kitty.nix
      ./neovim.nix
      ./sway
      # ./vscode.nix
      ./zsh.nix
    ];

    home.stateVersion = "21.11";
  };
}
