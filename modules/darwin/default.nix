{ lib, ... }:

with lib;

{
  shabka.keyboard.layouts = [ "colemak" ];
  shabka.fonts.enable = true;
  time.timeZone = "America/Los_Angeles";
}
