with import <shabka/util>;

let
  darwin = buildNixDarwinConfiguration { conf = ./configuration.nix; };
in {
  inherit (darwin) system;
}
