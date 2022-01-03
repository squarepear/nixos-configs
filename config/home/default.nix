{ ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  home-manager.users.jeffrey = { ... }: {
    programs.home-manager.enable = true;

    imports = [ ./pkgs.nix ];

    home.stateVersion = "21.11";
  };
}
