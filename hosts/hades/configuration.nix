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

  networking.hostName = "hades";

  # Switch to the flakes version of nix
  nix.extraOptions = ''
    builders-use-substitutes = true
    experimental-features = nix-command flakes
  '';
  nix.package = pkgs.nixFlakes;

  shabka.hardware.intel_backlight.enable = true;
  shabka.keyboard.layouts = [ "colemak" ];
  shabka.printing.enable = true;
  shabka.users.enable = true;
  shabka.virtualisation.docker.enable = true;
  shabka.virtualisation.libvirtd.enable = true;

  shabka.hardware.machine = "precision-7530";

  # Set the hardware clock to local time to support dual booting with Windows.
  time.hardwareClockInLocalTime = true;

  # Detect windows Hard Drive
  boot.loader.grub.useOSProber = true;

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

  # Synergy
  services.synergy.server = {
    enable = true;
  };

  environment.etc."synergy-server.conf".text = ''
    section: screens
      poseidon:
      hades:
      athena:
    end
    section: aliases
        poseidon:
          poseidon.admin.nasreddine.com
          poseidon.general.nasreddine.com
        hades:
          hades.admin.nasreddine.com
          hades.general.nasreddine.com
        athena:
          athena.admin.nasreddine.com
          athena.general.nasreddine.com
    end
    section: links
        poseidon:
          right = hades
        hades:
          left = poseidon
          right = athena
        athena:
          left = hades
    end
  '';

  networking.firewall.allowedTCPPorts = [
    # synergy support
    24800

    # shareable sevre_this
    7070
  ];

  # This value detershabkas the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
