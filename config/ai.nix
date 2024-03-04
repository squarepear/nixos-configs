# AI (ollama + rocm)
{ pkgs, ... }:

{
  services.ollama.enable = true;

  systemd.services.ollama.environment = {
    LD_LIBRARY_PATH = "${pkgs.rocmPackages.rocm-smi}/lib";
  };
}
