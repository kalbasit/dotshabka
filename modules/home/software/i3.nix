{ config, pkgs, lib, ... }:

with lib;

let
  defaultModifier = "Mod4";
  secondModifier = "Shift";
  thirdModifier = "Mod1";
  nosid = "--no-startup-id";
in {
  xsession.windowManager.i3.config = mkIf config.shabka.workstation.i3.enable {
    keybindings = {
      "${defaultModifier}+${thirdModifier}+s" = "exec ${nosid} ${getBin pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
    };


    startup = [
      { command = "${getBin pkgs.nitrogen}/bin/nitrogen --restore"; always = false; notification = false; }
    ];
  };
}
