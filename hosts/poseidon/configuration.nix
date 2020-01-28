{
  imports = [
    <shabka/modules/darwin>

    ./home.nix

    ../../modules/darwin
  ];

  networking.hostName = "poseidon";

  time.timeZone = "America/Los_Angeles";

  shabka.gnupg.enable = true;
}
