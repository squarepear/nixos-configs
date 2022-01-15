{ ... }:

{
  programs.home-manager.enable = true;

  imports = [ ./pkgs.nix ];

  home.stateVersion = "21.11";
}
