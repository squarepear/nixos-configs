{ pkgs, ... }:

{
  # Enable wayland screen sharing
  xdg.portal.wlr.enable = true;

  # Enable swaylock password authentication
  security.pam.services.swaylock = { };
}
