{ pkgs, ...}:

{
	# Enable swaylock password authentication
	security.pam.services.swaylock = {};
}