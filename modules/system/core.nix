{
  config,
  inputs,
  lib,
  pearlib,
  unstable,
  ...
}:

let
  cfg = config.pear.system.core;
in
{
  options.pear.system.core = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "minimal";
      description = "Baseline system defaults shared by all hosts.";
    };

    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "America/Indianapolis";
    };

    locale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
    };

    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "github:squarepear/nixos-configs";
    };
  };

  config = lib.mkIf cfg.enable {
    # Use latest nix version from unstable
    nix.package = unstable.nixVersions.latest;

    # Make `nixpkgs` available in `nix registry`.
    nix.registry.nixpkgs.flake = inputs.nixpkgs;

    # Set timezone + convenience TZ env.
    time.timeZone = cfg.timeZone;
    environment.sessionVariables.TZ = cfg.timeZone;

    # Locale + console.
    i18n.defaultLocale = cfg.locale;
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    # Remove duplicate files in nix store.
    nix.settings.auto-optimise-store = true;

    # Add default fonts.
    fonts.enableDefaultPackages = true;

    boot.tmp.cleanOnBoot = true;
    zramSwap.enable = true;

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 3";
      flake = cfg.flakePath;
    };

    system.autoUpgrade = {
      enable = true;
      flake = cfg.flakePath;
      dates = "*-*-* 02:00:00"; # Every day at 2am
      randomizedDelaySec = "45min";
    };

    # Enable flakes/nix-command.
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
