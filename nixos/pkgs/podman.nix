{ pkgs, ... }:

{
	virtualisation.podman = {
		enable = true;

		dockerCompat = true;
		dockerSocket.enable = true;
	};

	# Portainer agent port
	networking.firewall = {
		allowedTCPPorts = [ 9001 ];
		allowedUDPPorts = [ 9001 ];
	};
}
