{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master"; # Waiting for https://github.com/NixOS/nixpkgs/pull/338836 to reach nixos-unstable

    agenix.url = "github:ryantm/agenix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-vscode-server.url = "github:msteen/nixos-vscode-server";
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
