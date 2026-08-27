{
  config,
  inputs,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.desktop.niri;

  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [
    ./hm-base.nix
    ./mako.nix
    ./settings.nix
    ./tofi.nix
  ];

  options.pear.desktop.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.pear.desktop.environment == "niri";
    };

    unstable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];

    programs.niri = {
      enable = true;
      package =
        if cfg.unstable then
          inputs.niri.packages.${system}.niri-unstable
        else
          inputs.niri.packages.${system}.niri-stable;
    };

    programs.xwayland.enable = true;

    pear.programs = {
      vscode.enable = true;
      kitty.enable = true;
    };

    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = config.users.users.${config.pear.users.primaryUser}.name;
      };
    };

    systemd.user.services.niri.enableDefaultPath = false;

    home-manager.users = pearlib.perUser (_: {
      imports = [ inputs.niri.homeModules.niri ];

      programs.niri = {
        enable = true;
        package =
          if cfg.unstable then
            inputs.niri.packages.${system}.niri-unstable
          else
            inputs.niri.packages.${system}.niri-stable;

        settings = {

        };
      };
    });
  };
}
