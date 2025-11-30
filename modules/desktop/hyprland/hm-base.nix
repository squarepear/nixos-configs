{
  config,
  inputs,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      imports = [ inputs.hyprland.homeManagerModules.default ];

      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;

        plugins = lib.optionals cfg.enableSplitMonitorWorkspaces [
          inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
        ];
      };

      # Core user packages for the Hyprland desktop.
      home.packages = with pkgs; [
        # file manager
        nemo-with-extensions

        # general utilities used across modules
        xdg-utils
        wl-clipboard

        # hyprland utilities
        grimblast
        hyprpicker

        # qt wayland
        libsForQt5.qt5.qtwayland
        qt6.qtwayland

        # theme assets
        whitesur-gtk-theme
        whitesur-icon-theme
        numix-icon-theme-circle

        # cursors
        bibata-hyprcursor
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

      # Provide the hyprcursor theme as well.
      home.file.".icons/Bibata-Modern-Classic-hyprcursor".source =
        "${pkgs.bibata-hyprcursor}/share/icons/Bibata-Modern-Classic-hyprcursor";
      xdg.dataFile."icons/Bibata-Modern-Classic-hyprcursor".source =
        "${pkgs.bibata-hyprcursor}/share/icons/Bibata-Modern-Classic-hyprcursor";

      gtk = {
        enable = true;

        theme = {
          package = pkgs.whitesur-gtk-theme;
          name = "WhiteSur-Dark-solid";
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

        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
          gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
          gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
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
