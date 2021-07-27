{ pkgs, ... }:

{
  # Remove duplicate files in nix store
  nix.autoOptimiseStore = true;
  
  # Allow unfree packages (vscode, steam, ...)
  nixpkgs.config.allowUnfree = true;

  # Packages installed in system profile.
  environment.systemPackages = with pkgs; [
    killall
    neovim
    wget
    pfetch
    neofetch
    rsync
    git
    htop
    bat
    tree
    lm_sensors
    hddtemp
    pure-prompt
    cowsay
    unzip
    jq
  ];

  programs.noisetorch.enable = true;

  # Extra fonts
  fonts.fonts = with pkgs; [
    nerdfonts
  ];
}
