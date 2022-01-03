{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rsync
  ];

  # TODO
}
