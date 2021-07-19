{ pkgs, ... }:

{
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.jeffrey = { ... }: {
    programs.home-manager.enable = true;

    imports = [
      ./bat.nix
      ./brave.nix
      # ./dconf.nix
      ./git.nix
      ./kitty.nix
      ./neovim.nix
      ./sway
      # ./vscode.nix
      ./zsh.nix
    ];


    home.packages = with pkgs; [
      deno
    ];

    home.stateVersion = "21.11";
  };
}
