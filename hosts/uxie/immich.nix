{ ... }:

{
  services.immich = {
    enable = true;

    host = "0.0.0.0";
    openFirewall = true;
    mediaLocation = "/mnt/main-pool/homelab/immich/media";
    machine-learning.enable = false;
  };
}
