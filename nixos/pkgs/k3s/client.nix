{ pkgs, ... }:

{
	imports = [
		./default.nix
	];

	services.k3s = {
		role = "client";
		serverAddr = "https://100.114.164.19:6443";
	};
}
