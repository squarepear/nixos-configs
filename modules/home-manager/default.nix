{
  config,
  inputs,
  lib,
  ...
}:

let
  usersCfg = config.pear.users;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users = lib.genAttrs (lib.attrNames usersCfg.users) (name: {
      programs.home-manager.enable = true;

      home.stateVersion = "25.11";
    });
  };
}
