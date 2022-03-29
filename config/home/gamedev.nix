{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unityhub
    aseprite-unfree
    jetbrains.rider
    dotnet-sdk
    mono
  ];
}
