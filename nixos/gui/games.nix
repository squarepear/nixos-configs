{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		legendary-gl # Epic Games Store launcher
		multimc # Minecraft launcher

		sidequest # Oculus Quest sideload store

		mangohud # Game metrics HUD

		protonup # Proton-GE version manager
	];

	# Enable Java for MultiMC
	programs.java.enable = true;
	
	# Enable Steam
	programs.steam.enable = true;
	programs.steam.remotePlay.openFirewall = true;
	hardware.steam-hardware.enable = true;
}
	