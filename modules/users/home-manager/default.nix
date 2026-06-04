{
  inputs,
  pearlib,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users = pearlib.perUser (name: {
      programs.home-manager.enable = true;

      home.stateVersion = "26.05";
    });
  };
}
