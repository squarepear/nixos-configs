{ inputs, ... }:

{
  imports = [
    ./desktop
    ./development
    ./home-manager
    ./networking
    ./programs
    ./services
    ./users
    ./virtualization

    ./vendor.nix

    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.disko
  ];

  config = {
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    system.stateVersion = "25.11";
  };
}
