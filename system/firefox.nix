{ config, ... }:

{
  my.programs.firefox = {
    enable = config.pear.desktop.enable;
  };
}
