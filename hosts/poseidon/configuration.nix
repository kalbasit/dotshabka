{ lib, ... }:

with lib;

{
  imports = [
    <shabka/modules/darwin>

    ./home.nix

    ../../modules/darwin
  ]
  ++ (optionals (builtins.pathExists ./../../secrets/nix-darwin) (singleton ./../../secrets/nix-darwin));

  networking.hostName = "poseidon";

  shabka.gnupg.enable = true;
}
