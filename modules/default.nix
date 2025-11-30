{ inputs, lib, ... }:

{
  imports = [
    ./desktop
    ./programs
    ./services
    ./system
    ./users

    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.disko
  ];

  options.pear.isFreshInstall = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Whether this is a fresh install of the system. If true, certain
      configurations that should only be applied on first boot will be
      activated.
    '';
  };

  config = {
    system.stateVersion = "25.11";
  };
}
