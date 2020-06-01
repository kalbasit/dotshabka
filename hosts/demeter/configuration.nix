{ lib, ... }:

with lib;

let
  dotshabka = import ../.. { };
  hashedPassword = "$6$0bx5eAEsHJRxkD8.$gJ7sdkOOJRf4QCHWLGDUtAmjHV/gJxPQpyCEtHubWocHh9O7pWy10Frkm1Ch8P0/m8UTUg.Oxp.MB3YSQxFXu1";
in
{
  imports = [
    <shabka/modules/nixos>

    ./home.nix
  ]
  ++ (optionals (builtins.pathExists ./../../secrets/nixos) (singleton ./../../secrets/nixos));

  boot.tmpOnTmpfs = true;

  # set the default locale and the timeZone
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";

  networking.hostName = "demeter";

  # https://github.com/NixOS/nixpkgs/issues/62824
  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";

  shabka.hardware.machine = "cloud";

  shabka.users = {
    enable = true;

    users = {
      yl = { inherit hashedPassword; sshKeys = singleton dotshabka.external.kalbasit.keys; uid = 2000; isAdmin = true;  home = "/yl"; };
    };
  };

  shabka.virtualisation.docker.enable = true;

  # This value detershabkas the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
