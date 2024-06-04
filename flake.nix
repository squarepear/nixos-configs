{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";

    agenix.url = "github:ryantm/agenix";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-gaming.url = github:fufexan/nix-gaming;
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-vscode-server.url = github:msteen/nixos-vscode-server;
  };

  outputs = inputs: {
    nixosConfigurations =
      let
        host = system: modules: inputs.nixpkgs.lib.nixosSystem {
          system = system;
          modules = modules;

          specialArgs = { inherit inputs; };
        };
      in
      {
        altaria = (host "aarch64-linux" [ ./hosts/altaria ]);
        genesect = (host "x86_64-linux" [ ./hosts/genesect ]);
        reshiram = (host "x86_64-linux" [ ./hosts/reshiram ]);
        tepig = (host "aarch64-linux" [ ./hosts/tepig inputs.nixos-hardware.nixosModules.raspberry-pi-4 ]);
        torchic = (host "aarch64-linux" [ ./hosts/torchic ]);
      };
  };
}
