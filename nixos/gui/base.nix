{ pkgs, ... }:

{
	# Add default fonts
	fonts.enableDefaultFonts = true;

	# Sway greeter
	services.greetd = {
		enable = true;

		settings.default_session.command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
	};
}
