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

    # UI/UX related packages and modules
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    # Disk and boot management tools
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs =
    inputs:
    let
      nixos-hosts = [
        # "altaria"
        "reshiram"
        # "tepig"
        # "uxie"
      ];

      darwin-hosts = [
        # "kyurem"
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
                ./modules
              ];

              specialArgs = {
                inherit inputs;
                # lib.pear = "test";
              };
            };

          # Creates a set of systems with the given names
          mkSystems =
            systems: builtins.foldl' (acc: system: acc // { ${system} = mkSystem system; }) { } systems;
        in
        mkSystems nixos-hosts;

      darwinConfigurations =
        let
          mkSystem =
            name:
            inputs.nix-darwin.lib.darwinSystem {
              modules = [
                ./hosts/${name}
                ./darwin
              ];

              specialArgs = { inherit inputs; };
            };

          # Creates a set of systems with the given names
          mkSystems =
            systems: builtins.foldl' (acc: system: acc // { ${system} = mkSystem system; }) { } systems;
        in
        mkSystems darwin-hosts;

      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
