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
          ({...}: { nix.registry.nixpkgs.flake = nixpkgs; })
        ];
      };

      reshiram = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/reshiram
          home-manager.nixosModules.home-manager
          ({...}: { nix.registry.nixpkgs.flake = nixpkgs; })
        ];
      };

      shuckle = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/shuckle
          home-manager.nixosModules.home-manager
          ({...}: { nix.registry.nixpkgs.flake = nixpkgs; })
        ];
      };

      tepig = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/tepig
          home-manager.nixosModules.home-manager
          ({...}: { nix.registry.nixpkgs.flake = nixpkgs; })
        ];
      };

      torchic = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/torchic
          home-manager.nixosModules.home-manager
          ({...}: { nix.registry.nixpkgs.flake = nixpkgs; })
        ];
      };
    };
  };
}
