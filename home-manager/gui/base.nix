{ pkgs, ... }:

{
	home.packages = with pkgs; [
		apple-music-electron
		discord-canary
		feh
		libreoffice
		lxmenu-data
		mpv
		pcmanfm
		psensor
		shared_mime_info
		slack
		zoom-us
	];
}
