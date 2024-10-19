{ config, inputs, ... }:

{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    user = "jeffrey";

    mutableTaps = false;
    taps = {
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = builtins.attrNames config.nix-homebrew.taps;

    brews = [ ];

    casks = [
      "blender"
      "firefox"
      "freecad"
      "gswitch"
      "handbrake"
      "kicad"
      "krita"
      "logseq"
      "macs-fan-control"
      "makemkv"
      "melonds"
      "moonlight"
      "mpv"
      "obs"
      "ollama"
      "orcaslicer"
      "podman-desktop"
      "pokemon-tcg-live"
      "raspberry-pi-imager"
      "rectangle"
      "sidequest"
      "steam"
      "via"
    ];

    # masApps = {
    #   "AdGuard for Safari" = 1440147259;
    #   "Affinity Designer 2" = 1616831348;
    #   "Affinity Photo 2" = 1616822987;
    #   "Affinity Publisher 2" = 1606941598;
    #   "Refined GitHub" = 1519867270;
    # };
  };
}
