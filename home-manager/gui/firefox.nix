{ pkgs, ... }:

{
	programs.firefox = {
		enable = true;
		package = pkgs.firefox-wayland;
	};

	programs.browserpass = {
		enable = true;

		browsers = [ "firefox" ];
	};
}
