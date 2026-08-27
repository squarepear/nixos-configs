{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      # Core user packages for the Niri desktop.
      home.packages = with pkgs; [
        # file manager
        nemo-with-extensions

        # qt wayland
        libsForQt5.qt5.qtwayland
        qt6.qtwayland

        # theme assets
        whitesur-icon-theme
        numix-icon-theme-circle
        libadwaita
        gnome-themes-extra

        # cursors
        bibata-cursors

        # media
        feh
        mpv
      ];

      home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };

      gtk = {
        enable = true;

        theme = {
          package = pkgs.gnome-themes-extra;
          name = "Adwaita-dark";
        };

        iconTheme = {
          package = pkgs.whitesur-icon-theme;
          name = "WhiteSur";
        };

        gtk2.extraConfig = ''
          gtk-application-prefer-dark-theme = 1
          gtk-toolbar-style = "GTK_TOOLBAR_ICONS"
          gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR"
        '';

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
          gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
          gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        };

        gtk4 = {
          theme = lib.mkForce null;
          extraConfig = { };
        };
      };

      qt = {
        enable = true;
        platformTheme.name = "gtk";
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      xdg.mimeApps.defaultApplications = {
        "inode/directory" = "nemo.desktop;code.desktop;";
        "image/png" = "feh.desktop;";
        "image/jpeg" = "feh.desktop;";
        "image/gif" = "feh.desktop;";
        "video/mp4" = "mpv.desktop;";
        "video/x-matroska" = "mpv.desktop;";
      };
    });
  };
}
