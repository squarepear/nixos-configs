{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		unityhub
		dotnet-sdk
		mono
		aseprite # Pixel art editor
	];
}
