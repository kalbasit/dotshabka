{ pkgs, ... }:

{
  shabka.karabiner.enable = pkgs.stdenv.isDarwin;
}
