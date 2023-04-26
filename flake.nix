{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-gaming.url = github:fufexan/nix-gaming;
    nixos-vscode-server.url = github:msteen/nixos-vscode-server;
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs: {
    nixosConfigurations = {
      altaria = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/altaria ];

        specialArgs = { inherit inputs; };
      };

      genesect = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/genesect ];

        specialArgs = { inherit inputs; };
      };

      reshiram = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/reshiram ];

        specialArgs = { inherit inputs; };
      };

      shuckle = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/shuckle ];

        specialArgs = { inherit inputs; };
      };

      tepig = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/tepig

          inputs.nixos-hardware.nixosModules.raspberry-pi-4
        ];

        specialArgs = { inherit inputs; };
      };

      torchic = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/torchic ];

        specialArgs = { inherit inputs; };
      };
    };
  };
}
