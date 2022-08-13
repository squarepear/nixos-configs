{ config, pkgs, ... }:

{
  home.packages = if config.system.gui.enable then [ pkgs.pinentry-gtk2 ] else [ pkgs.pinentry-curses ];

  # Enable GPG
  programs.gpg = {
    enable = true;
  };

  # Enable GPG agent
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;

    pinentryFlavor = if config.system.gui.enable then "gtk2" else "curses";
  };

  # Enable gnome-keyring
  services.gnome-keyring.enable = true;

  # Enable password-store
  programs.password-store = {
    enable = true;
    package = with pkgs; (pass-wayland.withExtensions (ext: with ext; [
      pass-update
    ]));
  };

  # Enable pass-secret (gnome-keyring alternative)
  services.pass-secret-service.enable = true;

  services.password-store-sync = {
    enable = true;

    frequency = "*:0/5";
  };
}
