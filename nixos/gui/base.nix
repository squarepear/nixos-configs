{ pkgs, ... }:

{
	# use gnome keyring
	services.gnome.gnome-keyring.enable = true;

	# Sway greeter
	services.greetd = {
		enable = true;

		settings.default_session.command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
	};
}
