{ inputs, ... }:

{
  # Import config options and system packages
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ({ ... }: { nix.registry.nixpkgs.flake = inputs.nixpkgs; })

    ../options
    ./age.nix
    ./pkgs.nix
    ./colors.nix
  ];

  # Add custom overlay
  nixpkgs.overlays = [
    (import ../overlays)
  ];

  # Enable home manager
  my.programs.home-manager.enable = true;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Set timezone
  time.timeZone = "America/Indiana/Indianapolis";

  # Set localization options
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Remove duplicate files in nix store
  nix.settings.auto-optimise-store = true;

  # Add default fonts
  fonts.enableDefaultPackages = true;

  # Allow unfree packages (vscode, steam, ...)
  nixpkgs.config.allowUnfree = true;

  # Allow firmware with a redistribution license
  hardware.enableRedistributableFirmware = true;

  # Enable flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Used for auto completion
  environment.pathsToLink = [ "/share/zsh" ];

  my.home.stateVersion = "23.05";
  system.stateVersion = "23.05";
}
