{ lib, ... }:

with lib;

{
  imports = [
    <shabka/modules/nixos>
  ]
  ++ (optionals (builtins.pathExists ./../../secrets/nixos) (singleton ./../../secrets/nixos));

  # set the default locale and the timeZone
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";

  shabka.hardware.machine = "cloud";
  shabka.users.enable = false; # XXX: enable this for the root password but have to disable home-manager

  networking.hostName = "webserver-2";
}
