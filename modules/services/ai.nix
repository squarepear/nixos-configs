{ config, lib, ... }:

let
  cfg = config.pear.ai;
  vendor = config.pear.vendor;
in
{
  options.pear.ai = {
    enable = lib.mkEnableOption "AI services support (Ollama)";
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;

      host = "0.0.0.0";
      port = 11434;
    };

    nixpkgs.config.rocmSupport = lib.mkIf (vendor.gpu == "amd") true;
    nixpkgs.config.cudaSupport = lib.mkIf (vendor.gpu == "nvidia") true;
  };
}
