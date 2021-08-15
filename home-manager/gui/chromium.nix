{ pkgs, ... }:

{
	programs.chromium = {
		enable = true;

		extensions = [
			{ id = "blipmdconlkpinefehnmjammfjpmpbjk"; } # Lighthouse
			{ id = "ljjemllljcmogpfapbkkighbhhppjdbg"; } # Vue Devtools Beta
			{ id = "gcalenpjmijncebpfijmoaglllgpjagf"; } # Tampermonkey Beta
			{ id = "bkdgflcldnnnapblkhphbgpggdiikppg"; } # DuckDuckGo Privacy Essentials
			{ id = "dbfmnekepjoapopniengjbcpnbljalfg"; } # Infinity New Tab
		];
	};
}
