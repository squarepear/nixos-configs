{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.system.audio;
  desktopEnabled = pearlib.profileEnabled "desktop";
in
{
  options.pear.system.audio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = desktopEnabled;
      description = "Enable PipeWire audio stack and related tools.";
    };

    enableEasyEffects = lib.mkOption {
      type = lib.types.bool;
      default = desktopEnabled;
      description = "Enable EasyEffects (microphone noise suppression).";
    };
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    home-manager.users = pearlib.perUser (user: {
      home.packages = with pkgs; [
        pwvucontrol
        crosspipe
      ];

      services.easyeffects.enable = lib.mkIf cfg.enableEasyEffects true;
    });

    programs.dconf.enable = lib.mkIf cfg.enableEasyEffects true;

    pear.users.adminGroups = [ "audio" ];

    # Persist PipeWire and audio configuration
    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".local/state/wireplumber"
      ]
      ++ lib.optionals cfg.enableEasyEffects [
        ".config/easyeffects"
      ];

      persist.files = [
        ".config/easyeffectsrc"
      ];
    });
  };
}
