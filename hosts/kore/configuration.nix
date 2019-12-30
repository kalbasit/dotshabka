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
  services.unifi.enable = true;
  networking.firewall.allowedTCPPorts = [ 8443 ];

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
