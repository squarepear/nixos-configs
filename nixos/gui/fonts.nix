{ pkgs, ... }:

{
	# Extra fonts
	fonts.fonts = with pkgs; [
		nerdfonts
	];
}
