{
  config,
  lib,
  unstable,
  ...
}:

let
  cfg = config.pear.services.ai;
  vendor = config.pear.system.vendor;
in
{
  options.pear.services.ai = {
    enable = lib.mkEnableOption "AI services support (Ollama)";
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      package = unstable.ollama;

      host = "0.0.0.0";
      port = 11434;
    };

    nixpkgs.config.rocmSupport = lib.mkIf (vendor.gpu == "amd") true;
    nixpkgs.config.cudaSupport = lib.mkIf (vendor.gpu == "nvidia") true;
  };
}
