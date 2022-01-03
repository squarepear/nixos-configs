{ config, ... }:

{
  hardware.bluetooth.enable = true;
  services.blueman.enable = config.system.gui.enable;
}
