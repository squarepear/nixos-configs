{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.system.gui.enable {
    my.home.packages = with pkgs; [
      cider
    ];

  };
}
