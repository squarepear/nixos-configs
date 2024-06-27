{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-vscode-server.url = "github:msteen/nixos-vscode-server";
  };

  outputs = inputs: {
    nixosConfigurations =
      let
        mkSystem = name: inputs.nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/${name}
            ./lib
            ./modules
            ./pkgs
          ];

          specialArgs = { inherit inputs; };
        };

        # Creates a set of systems with the given names
        mkSystems = systems: builtins.foldl' (acc: system: acc // { ${system} = mkSystem system; }) { } systems;
      in
      mkSystems [
        "altaria"
        "reshiram"
        "tepig"
        "uxie"
      ];
  };
}
