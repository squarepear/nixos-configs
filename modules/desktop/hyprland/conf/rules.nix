{
  config,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      wayland.windowManager.hyprland.settings = {
        # window rules
        windowrule = [
          # ========================================
          # Popup Terminal
          # ========================================
          "float on, pin on, persistent_size off, rounding 0, size (monitor_w*0.8) (monitor_h*0.4), move (monitor_w-window_w)/2 (monitor_h-window_h), animation slide bottom, match:class ^popup-terminal$"

          # ========================================
          # CAD/Design Applications
          # ========================================
          # Blender render focus
          "idle_inhibit focus, match:class ^blender$, match:title ^Blender Render.*$"
          # FreeCAD/OpenSCAD render windows
          "idle_inhibit focus, match:class ^(freecad|openscad)$"
          # KiCad float dialogs
          "float on, center on, match:class ^(kicad|pcbnew|eeschema)$, match:title ^(Properties|Settings|Select|Library|Symbol|Footprint).*$"

          # ========================================
          # Development Tools
          # ========================================
          # Godot primary window
          "tag godot, float off, tile on, match:initial_class ^(Godot)$, match:initial_title ^(Godot)$"
          # Godot sub windows (not "Godot" or emptymatch:title)
          "tag godot_sub, float on, tile off, center on, dim_around on, match:initial_class ^(Godot)$, match:initial_title negative:^(Godot)?$"
          # Godot in-engine game preview
          "tag gaming, content game, float on, center on, match:initial_title ^Godot$, match:initial_class negative:^Godot$"
          # VSCode floating dialogs
          "float on, center on, match:class ^code$, match:title ^(Open File|Open Folder|Save|Settings).*$"

          # ========================================
          # File Managers
          # ========================================
          # File manager dialogs
          "float on, size 600 400, center on, match:class ^(nemo|org.gnome.Nautilus)$, match:title ^(Compress|Extract|Properties|Permissions).*$"

          # ========================================
          # Gaming and Emulation
          # ========================================
          # Tag gaming windows
          "tag gaming, content game, match:class ^(steam_app.*|gamescope|cemu|yuzu|Ryujinx|emulationstation|retroarch)$"
          "idle_inhibit focus, immediate on, no_anim on, decorate off, match:tag gaming"

          # ========================================
          # Media Players
          # ========================================
          # Cider mini player
          "float on, pin on, size 400 120, match:class ^sh.cider.genten$, match:title ^(Mini Player).*$"
          # Tag firefox windows playing media
          "tag media, content video, match:title ^(.*(Twitch|YouTube|Jellyfin)).*(Firefox).*$"
          # Tag mpv
          "tag media, content video, match:class ^mpv$"
          "idle_inhibit focus, match:tag media"
          # Picture-in-Picture
          "float on, pin on, match:title ^(Picture-in-Picture)$"

          # ========================================
          # Recording/Streaming
          # ========================================
          # OBS projector windows
          "float on, no_anim on, match:class ^com.obsproject.Studio$, match:title ^(Projector|Windowed Projector).*$"
          # OBS recording inhibit
          "idle_inhibit focus, match:class ^com.obsproject.Studio$"

          # ========================================
          # Social/Communication
          # ========================================
          # Discord popout windows
          "float on, match:class ^(discord|discordcanary)$, match:title ^(Discord Popout|Discord Voice|Discord Updater).*$"

          # ========================================
          # System Dialogs
          # ========================================
          # Polkit authentication
          "float on, center on, pin on, dim_around on, match:class ^(polkit-gnome-authentication-agent-1|org.kde.polkit-kde-authentication-agent-1)$"

          # ========================================
          # Virtualization
          # ========================================
          # Virt-manager VM windows
          "idle_inhibit focus, immediate on, match:class ^virt-manager$, match:title ^.*on QEMU/KVM.*$"
        ];

        # workspace rules
        workspace = [ "w[t1], gapsin:0, gapsout:0, border:0, rounding:0" ];
      };
    });
  };
}
