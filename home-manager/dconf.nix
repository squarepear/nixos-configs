# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

let
  mkTuple = lib.hm.gvariant.mkTuple;
in
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      clock-show-seconds = false;
      clock-show-weekday = false;
      cursor-theme = "WhiteSur-cursors";
      document-font-name = "NotoMono Nerd Font 11";
      enable-hot-corners = false;
      font-antialiasing = "rgba";
      font-hinting = "slight";
      font-name = "NotoMono Nerd Font 11";
      gtk-im-module = "gtk-im-context-simple";
      gtk-theme = "WhiteSur-dark";
      icon-theme = "WhiteSur-dark";
      monospace-font-name = "NotoMono Nerd Font Mono 11";
      show-battery-percentage = false;
      text-scaling-factor = 1.0;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize,maximize:appmenu";
      titlebar-font = "NotoMono Nerd Font 11";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      enabled-extensions = [ "apps-menu@gnome-shell-extensions.gcampax.github.com" "dash-to-plank@hardpixel.eu" "dash-to-panel@jderose9.github.com" "trayIconsReloaded@selfmade.pl" "sensory-perception@HarlemSquirrel.github.io" "transparent-window-moving@noobsai.github.com" "blur-my-shell@aunetx" "arcmenu@arcmenu.com" "no-overview@fthx" ];
      favorite-apps = [ "brave-browser.desktop" "org.gnome.Nautilus.desktop" "kitty.desktop" "code.desktop" ];
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      animate-appicon-hover = false;
      animate-appicon-hover-animation-extent = "{'RIPPLE': 4, 'PLANK': 4, 'SIMPLE': 1}";
      appicon-margin = 8;
      appicon-padding = 4;
      available-monitors = [ 0 ];
      dot-position = "BOTTOM";
      dot-style-focused = "METRO";
      dot-style-unfocused = "METRO";
      hot-keys = true;
      hotkeys-overlay-combo = "TEMPORARILY";
      intellihide = false;
      leftbox-padding = -1;
      panel-anchors = ''{"0":"MIDDLE"}'';
      panel-lengths = ''{"0":100}'';
      panel-sizes = ''{"0":48}'';
      show-appmenu = false;
      status-icon-padding = -1;
      trans-use-custom-bg = false;
      tray-padding = -1;
      window-preview-title-position = "TOP";
    };

    "org/gnome/shell/extensions/sensory-perception" = {
      display-decimal-value = true;
      display-label = false;
      main-sensor = "Average";
      unit = "Centigrade";
      update-time = 1;
    };

    "org/gnome/shell/extensions/trayIconsReloaded" = {
      icon-brightness = 0;
      icon-contrast = 0;
      icon-margin-horizontal = 2;
      icon-padding-horizontal = 10;
      icon-padding-vertical = 0;
      icon-saturation = 0;
      tray-margin-left = 4;
      tray-position = "right";
    };
  };
}
