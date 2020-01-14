{ config, pkgs, lib, ... }:

with lib;

let
  dotshabka = import ../.. { };
  apollo_ip = "192.168.52.2";
  unifi_config_gateway =
    let
      config = {
        system = {
          static-host-mapping = {
            host-name = {
              "apollo.nasreddine.com" = { inet = [apollo_ip]; };
              "plex.nasreddine.com" = { inet = [apollo_ip]; };
              "unifi.nasreddine.com" = { inet = [apollo_ip]; };
            };
          };
        };
      };
    in pkgs.writeText "config.gateway.json" (builtins.toJSON config);
in
{
  imports = [
    ./hardware-configuration.nix
  ]
  ++ (optionals (builtins.pathExists ./../../secrets/nixos) (singleton ./../../secrets/nixos));

  networking.hostName = "kore"; # Define your hostname.

  security.sudo.enable = true;
  time.timeZone = "America/Los_Angeles";
  environment.systemPackages = with pkgs; [
     vim
  ];

  users.users.root.openssh.authorizedKeys.keys = singleton dotshabka.external.kalbasit.keys;
  users.groups.builders = { gid = 1999; };

  services.openssh.enable = true;

  nix.trustedUsers = [
    "root" "@wheel" "@builders"
  ];

  # enable unifi and open the remote port
  networking.firewall.allowedTCPPorts = [ 8443 ];
  services.unifi = {
    enable = true;
    jrePackage = pkgs.jre8_headless;
    unifiPackage = pkgs.unifiStable;

    # Use the last known working mongodb package.
    # https://github.com/NixOS/nixpkgs/issues/75133
    mongodbPackage = let
      channelRelease = "nixos-19.09pre190687.3f4144c30a6";  # last known working mongo
      channelName = "unstable";
      url = "https://releases.nixos.org/nixos/${channelName}/${channelRelease}/nixexprs.tar.xz";
      sha256 = "040f16afph387s0a4cc476q3j0z8ik2p5bjyg9w2kkahss1d0pzm";

      pinnedNixpkgsFile = builtins.fetchTarball {
        inherit url sha256;
      };

      pinnedNixpkgs = import pinnedNixpkgsFile {};
    in pinnedNixpkgs.mongodb;
  };
  systemd.services.unifi.preStart = ''
    ln -nsf ${unifi_config_gateway} ${config.services.unifi.dataDir}/sites/default/config.gateway.json
  '';

  nixpkgs.config.allowUnfree = true;
  nixpkgs.system = "aarch64-linux";

  # configure OpenSSH server to listen on the ADMIN interface
  networking.firewall.enable = mkForce false; # TODO: Why do I have to disable firewall for the ifcadmin interface to work with port 22?
  services.openssh.listenAddresses = [ { addr = "192.168.2.6"; port = 22; } ];
  systemd.services.sshd = {
    after = ["network-addresses-ifcadmin.service"];
    requires = ["network-addresses-ifcadmin.service"];
    serviceConfig = {
      RestartSec = "5";
    };
  };

  networking.vlans = {
    # The ADMIN interface
    ifcadmin = {
      id = 2;
      interface = "eth0";
    };
  };

  networking.interfaces = {
    # The ADMIN interface
    ifcadmin = {
      useDHCP = true;
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
