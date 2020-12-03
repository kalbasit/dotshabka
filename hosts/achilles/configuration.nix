{ lib, pkgs, ... }:

with lib;

let
  shabka = import <shabka> { };

  nasreddineCA = builtins.readFile (builtins.fetchurl {
    url = "https://s3-us-west-1.amazonaws.com/nasreddine-infra/ca.crt";
    sha256 = "17x45njva3a535czgdp5z43gmgwl0lk68p4mgip8jclpiycb6qbl";
  });

in {
  imports = [
    ./hardware-configuration.nix

    #"${shabka.external.nixos-hardware.path}/dell/xps/13-9380"

    <shabka/modules/nixos>

    ./home.nix

    ../../modules/nixos
  ]
  ++ (optionals (builtins.pathExists ./../../secrets/nixos) (singleton ./../../secrets/nixos));

  boot.tmpOnTmpfs = true;

  # set the default locale and the timeZone
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";

  networking.hostName = "achilles";

  # Switch to the flakes version of nix
  nix.extraOptions = ''
    builders-use-substitutes = true
    experimental-features = nix-command flakes
  '';
  nix.package =
    let
      pkgs' = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/51aaa3fa1b69559456f9bd4968bd5b179a784f67.tar.gz";
        sha256 = "0n1g9dh0bwmxm9ivcn219dg6cd2f7qz5ni5a6a80z0zkaabj6pzm";
      }) {config = {}; overlays = [];};
    in pkgs'.nixFlakes;

  shabka.hardware.intel_backlight.enable = true;
  shabka.printing.enable = true;
  shabka.keyboard.layouts = [ "colemak" ];
  shabka.users.enable = true;
  shabka.virtualisation.docker.enable = true;
  shabka.virtualisation.libvirtd.enable = true;

  shabka.hardware.machine = "thinkpad-p1";

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  security.pki.certificates = [
    nasreddineCA
  ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp82s0.useDHCP = true;

  # This value detershabkas the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
