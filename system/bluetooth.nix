{ config, ... }:

{
  hardware.bluetooth.enable = true;
  services.blueman.enable = config.pear.desktop.enable;
}
