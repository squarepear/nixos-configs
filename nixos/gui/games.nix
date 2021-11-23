{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		legendary-gl # Epic Games Store launcher
		multimc # Minecraft launcher

		sidequest # Oculus Quest sideload store

		mangohud # Game metrics HUD

		protonup # Proton-GE version manager
		
		(steam.override { # Temporary fix for steam issues
			extraPkgs = pkgs: with pkgs; [ pango harfbuzz libthai ];
		})

		lutris # Game launcher
	];

	# Enable Java for MultiMC
	programs.java.enable = true;
	
	# Enable Steam
	programs.steam.enable = true;
	programs.steam.remotePlay.openFirewall = true;
	hardware.steam-hardware.enable = true;
}
	