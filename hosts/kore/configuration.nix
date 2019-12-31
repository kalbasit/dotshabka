{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "kore"; # Define your hostname.

  security.sudo.enable = true;
  time.timeZone = "America/Los_Angeles";
  environment.systemPackages = with pkgs; [
     vim
  ];

  services.openssh.enable = true;

  # enable unifi and open the remote port
  networking.firewall.allowedTCPPorts = [ 8443 ];
  services.unifi = {
    enable = true;
    jrePackage = pkgs.jre8_headless;

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

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
