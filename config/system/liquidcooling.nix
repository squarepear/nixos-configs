{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    liquidctl
  ];
}
