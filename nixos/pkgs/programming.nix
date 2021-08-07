{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		cargo
		deno
		go
		nodejs
		python3Full
		rustc
	];
}
