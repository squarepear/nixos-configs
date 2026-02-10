{
  inputs,
  lib,
  pkgs,
  ...
}:

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
    _module.args.unstable = import inputs.nixpkgs-unstable {
      inherit (pkgs.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };

    system.stateVersion = "25.11";
  };
}
