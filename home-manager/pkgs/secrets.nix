{ pkgs, ... }:

{
	home.packages = with pkgs; [
		pinentry-gtk2 # GTK pinentry
	];

	# Enable GPG
	programs.gpg = {
		enable = true;
	};

	# Enable GPG agent
	services.gpg-agent = {
		enable = true;
		enableSshSupport = true;

		pinentryFlavor = "gtk2";
	};

	# Enable password-store
	programs.password-store = {
		enable = true;
		package = with pkgs; (pass-wayland.withExtensions (ext: with ext; [
			pass-update
		]));
	};

	services.password-store-sync = {
		enable = true;

		frequency = "*:0/5";
	};
}