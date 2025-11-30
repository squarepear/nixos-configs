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

    enableNoiseTorch = lib.mkOption {
      type = lib.types.bool;
      default = desktopEnabled;
      description = "Enable NoiseTorch (microphone noise suppression).";
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
        helvum
      ];
    });

    pear.users.adminGroups = [ "audio" ];

    programs.noisetorch.enable = lib.mkIf cfg.enableNoiseTorch true;

    # Persist PipeWire and audio configuration
    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".local/state/wireplumber"
      ]
      ++ lib.optionals cfg.enableNoiseTorch [
        ".config/noisetorch"
      ];
    });
  };
}
