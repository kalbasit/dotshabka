{
  imports = [
    <shabka/modules/darwin>

    ./home.nix
  ];

  networking.hostName = "athena";

  time.timeZone = "America/Los_Angeles";

  shabka.gnupg.enable = true;
  shabka.keyboard.layouts = [ "colemak" ];
  shabka.fonts.enable = true;
}
