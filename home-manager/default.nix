{ ... }:

{
  imports = [
    ./base.nix
  ];

  home-manager.users.jeffrey = { ... }: {
    imports = [
      ./pkgs
      ./gui
    ];
  };
}
