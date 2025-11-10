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
  };

  security.pam.services."${config.pear.user.name}" = {
    enableGnomeKeyring = true;

    gnupg = {
      enable = true;
    };
  };

  services.gnome.gnome-keyring.enable = true;
}
