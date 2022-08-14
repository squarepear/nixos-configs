{ pkgs, ... }:

{
  my.home.packages = with pkgs; [
    swaylock
  ];

  my.programs.swaylock.settings = {
    color = "000000";
    font-size = 36;
    indicator-idle-visible = false;
    indicator-radius = 256;
    line-color = "101020";
    show-failed-attempts = false;
  };
}
