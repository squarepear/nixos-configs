{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf config.pear.desktop.enable {
    my.home.packages = with pkgs; [
      cider-2
    ];
  };
}
