{ pkgs, ... }:

{
  shabka.hammerspoon.enable = pkgs.stdenv.isDarwin;
}
