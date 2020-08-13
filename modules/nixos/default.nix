{ lib, pkgs, ... }:

with lib;

let
  dotshabka = import ../.. { };
  hashedPassword = "$6$0bx5eAEsHJRxkD8.$gJ7sdkOOJRf4QCHWLGDUtAmjHV/gJxPQpyCEtHubWocHh9O7pWy10Frkm1Ch8P0/m8UTUg.Oxp.MB3YSQxFXu1";
in
{
  shabka.workstation = {
    autorandr.enable = true;
    bluetooth.enable = true;
    fonts.enable = true;
    gnome-keyring.enable = true;
    gtk.enable = true;
    keeptruckin.enable = true;
    networking.enable = true;
    power.enable = true;
    redshift.enable = true;
    sound.enable = true;
    teamviewer.enable = true;
    virtualbox.enable = true;
    xorg.enable = true;
  };

  shabka.users.users = {
    yl = { inherit hashedPassword; sshKeys = singleton dotshabka.external.kalbasit.keys; uid = 2000; isAdmin = true;  home = "/yl"; };
  };

  environment.systemPackages = singleton pkgs.nix-diff;

  users.users.root.openssh.authorizedKeys.keys = singleton dotshabka.external.kalbasit.keys;

  # TODO: fix this!
  system.extraSystemBuilderCmds = ''ln -sfn /yl/.surfingkeys.js $out/.surfingkeys.js'';

  # L2TP VPN does not connect without the presence of this file!
  # https://github.com/NixOS/nixpkgs/issues/64965
  system.activationScripts.ipsec-secrets = ''
    touch $out/etc/ipsec.secrets
  '';
}
