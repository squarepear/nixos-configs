{ pkgs, ... }:

{
  # Pkgs to install
  environment.systemPackages = with pkgs; [
    python3Full
    deno
    nodejs
    go
    rustup
  ];

  programs.java.enable = true;
}
