{
  imports = [
    <shabka/modules/darwin>

    ./home.nix

    ../../modules/darwin
  ];

  networking.hostName = "athena";

  time.timeZone = "America/Los_Angeles";
}
