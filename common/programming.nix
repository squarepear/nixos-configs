{ pkgs, ... }:

{
  # Pkgs to install
  environment.systemPackages = with pkgs; [
    python3Full
    deno
    nodejs
    go
    rustc
    cargo
  ];

  programs.java.enable = true;
}
