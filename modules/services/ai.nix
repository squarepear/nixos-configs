{
  config,
  lib,
  pearlib,
  unstable,
  ...
}:

let
  cfg = config.pear.services.ai;
  vendor = config.pear.system.vendor;
in
{
  options.pear.services.ai = {
    enable = lib.mkEnableOption "AI services support";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (name: {
      home.packages = with unstable; [
        opencode
      ];
    });

    services.ollama = {
      enable = true;
      package =
        if vendor.gpu == "amd" then
          unstable.ollama-rocm
        else if vendor.gpu == "nvidia" then
          unstable.ollama-cuda
        else
          unstable.ollama;

      host = "0.0.0.0";
      port = 11434;
      home = "/persist/var/lib/ollama";

      user = "ollama";
      group = "ollama";
    };

    nixpkgs.config.rocmSupport = lib.mkIf (vendor.gpu == "amd") true;
    nixpkgs.config.cudaSupport = lib.mkIf (vendor.gpu == "nvidia") true;

    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".ollama"
        ".config/opencode"
      ];
    });
  };
}
