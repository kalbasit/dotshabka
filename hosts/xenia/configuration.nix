{ pkgs, lib, ... }:

with lib;

let
  shabka = import <shabka> { };
  dotshabka = import ../.. { };
  hashedPassword = "$6$0bx5eAEsHJRxkD8.$gJ7sdkOOJRf4QCHWLGDUtAmjHV/gJxPQpyCEtHubWocHh9O7pWy10Frkm1Ch8P0/m8UTUg.Oxp.MB3YSQxFXu1";

in {
  imports = [
    ./hardware-configuration.nix

    "${shabka.external.nixos-hardware.path}/common/cpu/intel"

    <shabka/modules/nixos>

    ./home.nix
  ]
  ++ (optionals (builtins.pathExists ./../../secrets/nixos) (singleton ./../../secrets/nixos));

  # set the default locale and the timeZone
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";

  networking.hostName = "xenia";

  shabka.keyboard.layouts = [ "colemak" ];
  shabka.neovim.enable = true;
  shabka.virtualisation.docker.enable = true;

  shabka.users = {
    enable = true;

    users = {
      yl = { inherit hashedPassword; sshKeys = singleton dotshabka.external.kalbasit.keys; uid = 2000; isAdmin = true;  home = "/yl"; };
    };
  };

  users.users.root.openssh.authorizedKeys.keys = singleton dotshabka.external.kalbasit.keys;

  #
  # Network
  #

  # networking.interfaces.enp3s0.useDHCP = true;
  # networking.interfaces.wlp4s0.useDHCP = true;

  networking.vlans = {
    # The ADMIN interface
    ifcadmin = {
      id = 2;
      interface = "enp3s0";
    };

    # # SN0 interface
    # ifcns0 = {
    #   id = 50;
    #   interface = "enp3s0";
    # };
    #
    # # SN1 interface
    # ifcns1 = {
    #   id = 51;
    #   interface = "enp3s0";
    # };
    #
    # # SN2 interface
    # ifcns2 = {
    #   id = 52;
    #   interface = "enp3s0";
    # };
    #
    # # SN3 interface
    # ifcns3 = {
    #   id = 53;
    #   interface = "enp3s0";
    # };
  };

  networking.interfaces = {
    # turn off DHCP on all real interfaces, I use virtual networks.
    enp3s0 = { useDHCP = false; };
    wlp4s0 = { useDHCP = false; };

    # The ADMIN interface
    ifcadmin = {
      useDHCP = true;
    };

    # # SN0 address
    # ifcns0 = {
    #   useDHCP = true;
    # };
    #
    # # SN1 address
    # ifcns1 = {
    #   useDHCP = true;
    # };
    #
    # # SN2 address
    # ifcns2 = {
    #   useDHCP = true;
    # };
    #
    # # SN3 address
    # ifcns3 = {
    #   useDHCP = true;
    # };
  };

  # This value detershabkas the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
