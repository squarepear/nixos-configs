{ pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable Gnome
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configuration
  services.dbus.packages = [ pkgs.gnome3.dconf ];
  services.udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];
  programs.gnupg.agent.pinentryFlavor = "gnome3";

  programs.xwayland.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    brave
    
    feh
    gparted
    psensor

    vscode

    discord
    slack
    zoom-us
    libreoffice
    apple-music-electron

    multimc

    # barrier

    gnome3.gnome-tweak-tool
    gnome.gnome-shell-extensions
    chrome-gnome-shell

    whitesur-gtk-theme
    whitesur-icon-theme
  ];

  # Disable built-ins
  programs.gnome-terminal.enable = false;

  # Expose barrier in firewall
  # networking.firewall.allowedTCPPorts = [ 24800 ];
  # networking.firewall.allowedUDPPorts = [ 24800 ];
}
