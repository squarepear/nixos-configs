{ pkgs, ... }:

{
	virtualisation.docker.enable = true;

	# Portainer agent port
	networking.firewall = {
		allowedTCPPorts = [ 9001 ];
		allowedUDPPorts = [ 9001 ];
	};
}
