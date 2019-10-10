{ pkgs, config, lib, ... }:

with lib;

let
  dotshabka = import ../.. { };
  shabka = import <shabka> { };
in {
  config = mkIf (config.shabka.darwinConfig != {}) {
    home.file = {
      ".ssh/authorized_keys".text = dotshabka.external.kalbasit.keys;
    };
  };
}

