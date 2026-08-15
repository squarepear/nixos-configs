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
        window_rule = [
          # Popup Terminal
          {
            float = true;
            pin = true;
            persistent_size = false;
            rounding = 0;
            size = "(monitor_w*0.8) (monitor_h*0.4)";
            move = "(monitor_w-window_w)/2 (monitor_h-window_h)";
            animation = "slide bottom";
            match.class = "^popup-terminal$";
          }

          # Blender render focus
          {
            idle_inhibit = "focus";
            match = {
              class = "^blender$";
              title = "^Blender Render.*$";
            };
          }

          # FreeCAD/OpenSCAD render windows
          {
            idle_inhibit = "focus";
            match.class = "^(freecad|openscad)$";
          }

          # KiCad float dialogs
          {
            float = true;
            center = true;
            match = {
              class = "^(kicad|pcbnew|eeschema)$";
              title = "^(Properties|Settings|Select|Library|Symbol|Footprint).*$";
            };
          }

          # Godot primary window
          {
            tag = "godot";
            float = false;
            tile = true;
            match = {
              initial_class = "^(Godot)$";
              initial_title = "^(Godot)$";
            };
          }

          # Godot sub windows
          {
            tag = "godot_sub";
            float = true;
            tile = false;
            center = true;
            dim_around = true;
            match = {
              initial_class = "^(Godot)$";
              initial_title = "negative:^(Godot)?$";
            };
          }

          # Godot in-engine game preview
          {
            tag = "gaming";
            content = "game";
            float = true;
            center = true;
            match = {
              initial_title = "^Godot$";
              initial_class = "negative:^Godot$";
            };
          }

          # VSCode floating dialogs
          {
            float = true;
            center = true;
            match = {
              class = "^code$";
              title = "^(Open File|Open Folder|Save|Settings).*$";
            };
          }

          # File manager dialogs
          {
            float = true;
            size = "600 400";
            center = true;
            match = {
              class = "^(nemo|org.gnome.Nautilus)$";
              title = "^(Compress|Extract|Properties|Permissions).*$";
            };
          }

          # Tag gaming windows
          {
            tag = "gaming";
            content = "game";
            match.class = "^(steam_app.*|gamescope|cemu|yuzu|Ryujinx|emulationstation|retroarch)$";
          }

          # Tag gaming behavior
          {
            idle_inhibit = "focus";
            immediate = true;
            no_anim = true;
            decorate = false;
            match.tag = "gaming";
          }

          # Cider mini player
          {
            float = true;
            pin = true;
            size = "400 120";
            match = {
              class = "^sh.cider.genten$";
              title = "^(Mini Player).*$";
            };
          }

          # Tag firefox media
          {
            tag = "media";
            content = "video";
            match.title = "^(.*(Twitch|YouTube|Jellyfin)).*(Firefox).*$";
          }

          # Tag mpv
          {
            tag = "media";
            content = "video";
            match.class = "^mpv$";
          }

          # Media tag behavior
          {
            idle_inhibit = "focus";
            match.tag = "media";
          }

          # Picture-in-Picture
          {
            float = true;
            pin = true;
            match.title = "^(Picture-in-Picture)$";
          }

          # OBS projector windows
          {
            float = true;
            no_anim = true;
            match = {
              class = "^com.obsproject.Studio$";
              title = "^(Projector|Windowed Projector).*$";
            };
          }

          # OBS recording inhibit
          {
            idle_inhibit = "focus";
            match.class = "^com.obsproject.Studio$";
          }

          # Discord popouts
          {
            float = true;
            match = {
              class = "^(discord|discordcanary)$";
              title = "^(Discord Popout|Discord Voice|Discord Updater).*$";
            };
          }

          # Polkit authentication
          {
            float = true;
            center = true;
            pin = true;
            dim_around = true;
            match.class = "^(polkit-gnome-authentication-agent-1|org.kde.polkit-kde-authentication-agent-1)$";
          }

          # Virt-manager VM windows
          {
            idle_inhibit = "focus";
            immediate = true;
            match = {
              class = "^virt-manager$";
              title = "^.*on QEMU/KVM.*$";
            };
          }
        ];

        workspace_rule = [
          {
            workspace = "w[t1]";
            gaps_in = 0;
            gaps_out = 0;
            no_border = true;
            no_rounding = true;
          }
        ];
      };
    });
  };
}
