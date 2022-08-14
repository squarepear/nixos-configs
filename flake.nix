{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, home-manager, nixpkgs }: {
    nixosConfigurations = {
      genesect = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/genesect
          home-manager.nixosModules.home-manager
        ];
      };

      reshiram = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/reshiram
          home-manager.nixosModules.home-manager
        ];
      };

      shuckle = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/shuckle
          home-manager.nixosModules.home-manager
        ];
      };

      tepig = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/tepig
          home-manager.nixosModules.home-manager
        ];
      };

      torchic = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/torchic
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
