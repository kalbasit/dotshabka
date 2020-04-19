{
  imports = [
    <shabka/modules/darwin>

    ./home.nix

    ../../modules/darwin
  ]
  ++ (optionals (builtins.pathExists ./../../secrets/nix-darwin) (singleton ./../../secrets/nix-darwin));

  networking.hostName = "poseidon";

  time.timeZone = "America/Los_Angeles";

  shabka.gnupg.enable = true;
}
