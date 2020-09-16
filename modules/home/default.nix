{ pkgs, ... }:

with import <shabka/util>;

{
  imports = recImport ./.;

	config = {
		dotshabka.brave.enable = true;
		dotshabka.chromium.enable = true;
		dotshabka.chromium.surfingkeys.enable = true;

		home.packages = with pkgs; [ nitrogen ];
	};
}
