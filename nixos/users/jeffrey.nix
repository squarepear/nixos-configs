{ pkgs, ... }:

{
	users.users.jeffrey = {
		isNormalUser = true;
		home = "/home/jeffrey";
		description = "Jeffrey Harmon";
		extraGroups = [ "wheel" "libvirtd" "podman" ];
		shell = pkgs.zsh;
	};
}
