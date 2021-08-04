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
      seatd
      libnotify
      xdg-desktop-portal-wlr
      xorg.xlsclients

      # lxappearance
      qt5.qtwayland
      glfw-wayland
      whitesur-gtk-theme
      whitesur-icon-theme
      quintom-cursor-theme
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
    pcmanfm

    vscode

    discord-canary
    slack
    zoom-us
    libreoffice
    apple-music-electron
  ];

  # Expose barrier in firewall
  # networking.firewall.allowedTCPPorts = [ 24800 ];
  # networking.firewall.allowedUDPPorts = [ 24800 ];
}
