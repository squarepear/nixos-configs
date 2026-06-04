{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./desktop
    ./lab
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
    nixpkgs.config.allowUnfree = true;

    _module.args.unstable = import inputs.nixpkgs-unstable {
      inherit (pkgs.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };

    system.stateVersion = "26.05";
  };
}
