{ pkgs, ... }:

{
	users.users.jeffrey = {
		isNormalUser = true;
		home = "/home/jeffrey";
		description = "Jeffrey Harmon";
		extraGroups = [ "wheel" "libvirtd" "docker" ];
		shell = pkgs.zsh;
	};

	nix.trustedUsers = [
		"jeffrey"
	];
}
