{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.system.secrets;
in
{
  options.pear.system.secrets = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "minimal";
      description = "GPG + gpg-agent + keyring integration.";
    };
  };

  config = lib.mkIf cfg.enable {
    # System-wide gnome-keyring service (needed for PAM integration).
    services.gnome.gnome-keyring.enable = true;

    home-manager.users = pearlib.perUser (_: {
      programs.gpg.enable = true;

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;

        pinentry.package = if config.pear.desktop.enable then pkgs.pinentry-qt else pkgs.pinentry-curses;
      };

      services.gnome-keyring.enable = true;
    });

    # Enable gpg + gnome-keyring PAM hooks for every declared user.
    security.pam.services = pearlib.perUser (_: {
      enableGnomeKeyring = true;
      gnupg.enable = true;
    });

    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".gnupg"
        ".local/share/keyrings"
      ];
    });
  };
}
