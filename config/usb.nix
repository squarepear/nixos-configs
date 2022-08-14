{ ... }:

{
  # USB auto-mount
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
}
