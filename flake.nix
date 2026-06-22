{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # UI/UX related packages and modules
    # use commit ee67278038b5b6597172b2a3ee9d57f6ad0eafc7 to fix no mouse cursor issue
    hyprland.url = "github:hyprwm/Hyprland";
    # hyprland.url = "github:hyprwm/Hyprland/ee67278038b5b6597172b2a3ee9d57f6ad0eafc7";
    hyprland.inputs.nixpkgs.follows = "nixpkgs-unstable";
    split-monitor-workspaces.url = "github:Duckonaut/split-monitor-workspaces";
    split-monitor-workspaces.inputs.hyprland.follows = "hyprland";

    # Disk and boot management tools
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    impermanence.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.inputs.home-manager.follows = "home-manager";
    lanzaboote.url = "github:nix-community/lanzaboote/v1.0.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    # Homelab related modules and packages
    copyparty.url = "github:9001/copyparty";
    copyparty.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Hardware-specific NixOS modules (raspberry-pi-4, gigabyte-b550, etc.)
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    let
      hosts = {
        altaria = "aarch64-linux";
        reshiram = "x86_64-linux";
        tepig = "aarch64-linux";
        uxie = "x86_64-linux";
      };
    in
    {
      nixosConfigurations =
        let
          mkSystem =
            name: system:
            inputs.nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                ./hosts/${name}
                ./lib
                ./modules
                ./pkgs
              ];

              specialArgs = {
                inherit inputs;
              };
            };

          # Creates a set of systems with the given names
          mkSystems = hosts: builtins.mapAttrs mkSystem hosts;
        in
        mkSystems hosts;

      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
