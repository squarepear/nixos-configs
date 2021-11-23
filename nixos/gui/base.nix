{ lib, pkgs, ... }:

{
	# Add default fonts
	fonts.enableDefaultFonts = true;

	# Text UI greeter
	services.greetd = {
		enable = true;
		package = pkgs.greetd.tuigreet;

		settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet -tr --asterisks --greeting \"This legendary Pokémon can scorch the world with fire. It helps those who want to build a world of truth.\" --cmd sway";
	};

	systemd.services.greetd = {
		unitConfig = {
			After = lib.mkOverride 0 [ "multi-user.target" ];
		};
		serviceConfig = {
			Type = "idle";
		};
	};

	# Greeter group
	users.users.greeter.group = "greeter";
	users.groups.greeter = {};
}
