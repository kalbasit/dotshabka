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
  docker-containers.unifi = {
    # jacobalberty/unifi:arm32v7
    # https://hub.docker.com/layers/jacobalberty/unifi/arm32v7/images/sha256-c921fc8b20449e12a5342696d8266967c09e16c7aad0c3febca0ca5db5e35bd0
    image = "jacobalberty/unifi@sha256:c921fc8b20449e12a5342696d8266967c09e16c7aad0c3febca0ca5db5e35bd0";
    extraDockerOptions = ["--network=host"];
    environment = {
      TZ = "America/Los_Angeles";
      RUNAS_UID0 = "false";
    };
    volumes = [
      "/unifi:/unifi"
    ];
  };
  networking.firewall = {
    # https://help.ubnt.com/hc/en-us/articles/218506997
    allowedTCPPorts = [
      8080  # Port for UAP to inform controller.
      8880  # Port for HTTP portal redirect, if guest portal is enabled.
      8843  # Port for HTTPS portal redirect, ditto.
      6789  # Port for UniFi mobile speed test.
      8443  # Port for UniFi remote management
    ];
    allowedUDPPorts = [
      3478  # UDP port used for STUN.
      10001 # UDP port used for device discovery.
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
