{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		unityhub
		jetbrains.rider # JetBrains C#/dotnet editor
		dotnet-sdk
		aseprite # Pixel art editor
	];
}
