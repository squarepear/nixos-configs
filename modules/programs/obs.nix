{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.programs.obs;
in
{
  options.pear.programs.obs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "desktop";
      description = "Enable OBS Studio for all users (home-manager).";
    };

    enableVirtualCamera = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the OBS virtual camera.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = cfg.enableVirtualCamera;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        droidcam-obs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };
  };
}
