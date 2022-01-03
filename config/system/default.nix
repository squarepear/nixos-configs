{ ... }:

{
  # Import config options and system packages
  imports = [ ../options ./pkgs.nix ];

  # Set timezone
  time.timeZone = "America/Indiana/Indianapolis";

  # Set localization options
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Remove duplicate files in nix store
  nix.autoOptimiseStore = true;

  # Add default fonts
  fonts.enableDefaultFonts = true;

  # Allow unfree packages (vscode, steam, ...)
  nixpkgs.config.allowUnfree = true;

  # Allow firmware with a redistribution license
  hardware.enableRedistributableFirmware = true;

  # Enable flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.stateVersion = "22.05";
}
