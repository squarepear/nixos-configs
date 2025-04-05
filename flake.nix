{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    agenix.url = "github:ryantm/agenix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-vscode-server.url = "github:msteen/nixos-vscode-server";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = inputs:
    let
      nixos-hosts = [
        "altaria"
        "reshiram"
        "tepig"
        "uxie"
      ];

      darwin-hosts = [
        "kyurem"
      ];
    in
    {
      nixosConfigurations =
        let
          mkSystem = name: inputs.nixpkgs.lib.nixosSystem {
            modules = [
              ./hosts/${name}
              ./lib
              ./modules
              ./pkgs
              ./system
            ];

            specialArgs = { inherit inputs; };
          };

          # Creates a set of systems with the given names
          mkSystems = systems: builtins.foldl' (acc: system: acc // { ${system} = mkSystem system; }) { } systems;
        in
        mkSystems nixos-hosts;

      darwinConfigurations =
        let
          mkSystem = name: inputs.nix-darwin.lib.darwinSystem {
            modules = [
              ./hosts/${name}
              ./darwin
            ];

            specialArgs = { inherit inputs; };
          };

          # Creates a set of systems with the given names
          mkSystems = systems: builtins.foldl' (acc: system: acc // { ${system} = mkSystem system; }) { } systems;
        in
        mkSystems darwin-hosts;
    };
}
