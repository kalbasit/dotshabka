{ lib, ... }:

with lib;

{
  shabka.keyboard.layouts = [ "colemak" ];
  shabka.fonts.enable = true;
  time.timeZone = "America/Los_Angeles";

  # TODO: fix this!
  system.activationScripts.postActivation.text = ''
    ln -sfn /Users/yl/.surfingkeys.js $systemConfig/.surfingkeys.js
  '';
}
