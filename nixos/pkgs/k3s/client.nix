{ pkgs, ... }:

{
	imports = [
		./default.nix
	];

	services.k3s.role = "client";
}
