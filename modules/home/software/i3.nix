{ config, pkgs, lib, ... }:

with lib;

let
  defaultModifier = "Mod4";
  secondModifier = "Shift";
  thirdModifier = "Mod1";
  nosid = "--no-startup-id";
in {
  xsession.windowManager.i3.config.keybindings = mkIf config.shabka.workstation.i3.enable {
    "${defaultModifier}+${thirdModifier}+s" = "exec ${nosid} ${getBin pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
  };
}
