{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pear.system.secureboot;
in
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  options.pear.system.secureboot = {
    enable = lib.mkEnableOption "Enable secure boot with lanzaboote";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      # For debugging and troubleshooting Secure Boot.
      pkgs.sbctl
    ];

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    pear.system.impermanence.persist.directories = [
      "/var/lib/sbctl"
    ];
  };
}
