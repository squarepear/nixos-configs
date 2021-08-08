{ pkgs, ... }:

{
	fonts.enableDefaultFonts = true;

	# Extra fonts
	fonts.fonts = with pkgs; [
		nerdfonts
	];
}
