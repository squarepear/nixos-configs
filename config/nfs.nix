{ pkgs, ... }:

{
  services.rpcbind.enable = true;

  environment.systemPackages = with pkgs; [
    nfs-utils
  ];
}
