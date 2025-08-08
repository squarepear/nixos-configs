{ config, pkgs, ... }:

{
  my = {
    # Enable GPG
    programs.gpg = {
      enable = true;
    };

    # Enable GPG agent
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;

      pinentry.package = if config.pear.desktop.enable then pkgs.pinentry-qt else pkgs.pinentry-curses;
    };

    # Enable gnome-keyring
    services.gnome-keyring.enable = true;

    # Enable password-store
    programs.password-store = {
      enable = true;
      package =
        with pkgs;
        (pass-wayland.withExtensions (
          ext: with ext; [
            pass-update
          ]
        ));
    };

    # Enable pass-secret (gnome-keyring alternative)
    # services.pass-secret-service.enable = true;

    services.git-sync = {
      enable = true;

      repositories = {
        password-store = {
          path = "/home/${config.pear.user.name}/.password-store";
          uri = "https://github.com/squarepear/password-store.git";
        };
      };
    };
  };

  security.pam.services."${config.pear.user.name}" = {
    enableGnomeKeyring = true;

    gnupg = {
      enable = true;
    };
  };

  services.gnome.gnome-keyring.enable = true;
}
