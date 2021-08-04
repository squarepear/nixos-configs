{ pkgs, ... }:

{
  # Pkgs to install
  environment.systemPackages = with pkgs; [
    unityhub
    jetbrains.rider
    dotnet-sdk
  ];
}
