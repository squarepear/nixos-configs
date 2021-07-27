{ pkgs, ... }:

{
  # use gnome keyring
  services.gnome.gnome-keyring.enable = true;

  services.greetd = {
    enable = true;

    settings.default_session.command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
  };

  # Enable sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

     extraPackages = with pkgs; [
      swaylock-fancy
      swayidle
      wl-clipboard
      mako
      wofi
      waybar
      sway-contrib.grimshot
      swaybg
      libnotify
      xdg-desktop-portal-wlr
      qt5.qtwayland

      quintom-cursor-theme
      adwaita-qt
    ];
  };

  # Configuration
  programs.xwayland.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    brave
    
    feh
    mpv
    
    gparted
    psensor
    dolphin

    vscode

    discord
    slack
    zoom-us
    libreoffice
    apple-music-electron
  ];

  # Expose barrier in firewall
  # networking.firewall.allowedTCPPorts = [ 24800 ];
  # networking.firewall.allowedUDPPorts = [ 24800 ];
}
