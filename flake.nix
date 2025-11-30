{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
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
  };

  outputs =
    inputs:
    let
      hosts = [
        # "altaria"
        "reshiram"
        # "tepig"
        # "uxie"
      ];
    in
    {
      nixosConfigurations =
        let
          mkSystem =
            name:
            inputs.nixpkgs.lib.nixosSystem {
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
          mkSystems =
            systems: builtins.foldl' (acc: system: acc // { ${system} = mkSystem system; }) { } systems;
        in
        mkSystems hosts;

      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
