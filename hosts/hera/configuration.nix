{ lib, ... }:

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

    "${shabka.external.nixos-hardware.path}/common/cpu/intel"
    "${shabka.external.nixos-hardware.path}/common/pc/laptop"
    "${shabka.external.nixos-hardware.path}/common/pc/laptop/ssd"

    <shabka/modules/nixos>

    ./home.nix

    ../../modules/nixos
  ]
  ++ (optionals (builtins.pathExists ./../../secrets/nixos) (singleton ./../../secrets/nixos));

  boot.tmpOnTmpfs = true;

  # set the default locale and the timeZone
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";

  networking.hostName = "hera";

  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  shabka.hardware.intel_backlight.enable = true;
  shabka.printing.enable = true;
  shabka.keyboard.layouts = [ "colemak" ];
  shabka.users.enable = true;
  shabka.virtualisation.docker.enable = true;

  shabka.hardware.machine = "precision-7530";

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  security.pki.certificates = [
    nasreddineCA
  ];

  services.snapper = {
    configs = {
      "code" = {
        subvolume = "/yl/code";
      };

      "home" = {
        subvolume = "/home";
      };

      "private" = {
        subvolume = "/yl/private";
      };
    };
  };

  # This value detershabkas the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
