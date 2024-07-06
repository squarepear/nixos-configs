{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    curl
    vim
    nil
    nixpkgs-fmt
    pfetch-rs
  ];
}
