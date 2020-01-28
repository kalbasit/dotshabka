{ lib, ... }:

with lib;

{
  shabka.keyboard.layouts = [ "colemak" ];
  shabka.fonts.enable = true;

  # override the binary caches to remove cache.nixos.org over https
  nix.binaryCaches = mkForce [
    "http://cache.nixos.org"
    "http://yl.cachix.org"
    "http://risson.cachix.org"
  ];
}
