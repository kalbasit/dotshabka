{ pkgs, lib, ... }:

with lib;

let
  shabka = import <shabka> { };
  dotshabka = import ../.. { };
  hashedPassword = "$6$0bx5eAEsHJRxkD8.$gJ7sdkOOJRf4QCHWLGDUtAmjHV/gJxPQpyCEtHubWocHh9O7pWy10Frkm1Ch8P0/m8UTUg.Oxp.MB3YSQxFXu1";

  nasIP = "192.168.53.2";

  buildWindows10 = env: let
    vmName = if env == "prod" then "win10"
      else if env == "staging" then "win10.staging"
      else abort "${env} is not supported";
  in {
    after = ["libvirtd.service" "iscsid.service" "iscsid-nas.service"];
    requires = ["libvirtd.service" "iscsid.service" "iscsid-nas.service"];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    restartIfChanged = false;

    script = let
      xml = pkgs.substituteAll {
        src = ./win10.xml;

        name = vmName;

        mac_address = if env == "prod" then "52:54:00:54:35:95"
        else if env == "staging" then "02:68:b3:29:da:98"
        else abort "${env} is not supported";

        dev_path = if env == "prod" then "/dev/disk/by-path/ip-${nasIP}:3260-iscsi-iqn.2018-11.com.nasreddine.apollo:win10-lun-1"
        else if env == "staging" then "/dev/disk/by-path/ip-${nasIP}:3260-iscsi-iqn.2018-11.com.nasreddine.apollo:win10.staging-lun-1"
        else abort "${env} is not supported";

        source_dev = "ifcns1";
      };

    in ''
      uuid="$(${getBin pkgs.libvirt}/bin/virsh domuuid '${vmName}' || true)"
        ${getBin pkgs.libvirt}/bin/virsh define <(sed "s/UUID/$uuid/" '${xml}')
        ${getBin pkgs.libvirt}/bin/virsh start '${vmName}'
    '';

    preStop = ''
      ${getBin pkgs.libvirt}/bin/virsh shutdown '${vmName}'
      let "timeout = $(date +%s) + 120"
      while [ "$(${getBin pkgs.libvirt}/bin/virsh list --name | grep --count '^${vmName}$')" -gt 0 ]; do
        if [ "$(date +%s)" -ge "$timeout" ]; then
          # Meh, we warned it...
          ${getBin pkgs.libvirt}/bin/virsh destroy '${vmName}'
        else
          # The machine is still running, let's give it some time to shut down
          sleep 0.5
        fi
      done
    '';
  };

in {
  imports = [
    ./hardware-configuration.nix

    "${shabka.external.nixos-hardware.path}/common/cpu/intel"
    "${shabka.external.nixos-hardware.path}/common/pc/ssd"

    <shabka/modules/nixos>

    ./home.nix
  ]
  ++ (optionals (builtins.pathExists ./../../secrets/nixos) (singleton ./../../secrets/nixos));

  # set the default locale and the timeZone
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";

  networking.hostName = "zeus";

  shabka.keyboard.layouts = [ "colemak" ];
  shabka.neovim.enable = true;
  shabka.virtualisation.libvirtd.enable = true;

  shabka.users = {
    enable = true;

    users = {
      yl = { inherit hashedPassword; sshKeys = singleton dotshabka.external.kalbasit.keys; uid = 2000; isAdmin = true;  home = "/yl"; };
    };
  };

  users.users.root.openssh.authorizedKeys.keys = singleton dotshabka.external.kalbasit.keys;

  shabka.hardware.machine = "zeus";

  # override the binary caches to remove cache.nixos.org over https
  nix.binaryCaches = mkForce [
    "http://cache.nixos.org"
    "http://yl.cachix.org"
    "http://risson.cachix.org"
  ];

  # enable iScsi with libvirtd
  nixpkgs.overlays = [
    (self: super: {
      libvirt = super.libvirt.override {
        enableIscsi = true;
      };
    })
  ];

  # start iscsid
  systemd.services.iscsid = {
    wantedBy = [ "multi-user.target" ];
    before = ["libvirtd.service"];
    serviceConfig.ExecStart = "${getBin pkgs.openiscsi}/bin/iscsid --foreground";
    restartIfChanged = false;
  };
  systemd.services.iscsid-nas = {
    wantedBy = [ "multi-user.target" ];
    after = ["iscsid.service"];
    requires = ["iscsid.service"];
    restartIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = let
      prodIQN = "iqn.2018-11.com.nasreddine.apollo:win10";
      stagingIQN = "iqn.2018-11.com.nasreddine.apollo:win10.staging";
    in ''
      export PATH="$PATH:${getBin pkgs.openiscsi}/bin"

      if ! [[ -f /etc/iscsi/initiatorname.iscsi ]]; then
        mkdir -p /etc/iscsi
        echo "InitiatorName=$(iscsi-iname)" > /etc/iscsi/initiatorname.iscsi
      fi

      # run iscsi discover, this might fail and that's OK!
      let "timeout = $(date +%s) + 60"
      while ! iscsi_discovery ${nasIP}; do
        if [ "$(date +%s)" -ge "$timeout" ]; then
          echo "unable to run iscsi_discovery, going to skip this step"
          break
        else
          sleep 0.5
        fi
      done

      # discover all the iSCSI defices offered by my NAS
      let "timeout = $(date +%s) + 60"
      while ! iscsiadm --mode discovery --type sendtargets --portal ${nasIP}; do
        if [ "$(date +%s)" -ge "$timeout" ]; then
          echo "iSCSI is still not up, aborting"
          exit 1
        else
          sleep 0.5
        fi
      done

      # Login to the IQN
      if ! iscsiadm -m session | grep -q ' ${prodIQN} '; then
        iscsiadm -m node -T ${prodIQN} -p ${nasIP} -l
      fi
      if ! iscsiadm -m session | grep -q ' ${stagingIQN} '; then
        iscsiadm -m node -T ${stagingIQN} -p ${nasIP} -l
      fi
    '';
  };

  # start windows 10 VM
  systemd.services.libvirtd-guest-win10 = buildWindows10 "prod";
  # systemd.services.libvirtd-guest-win10-staging = buildWindows10 "staging";

  # configure OpenSSH server to listen on the ADMIN interface
  services.openssh.listenAddresses = [ { addr = "192.168.2.3"; port = 22; } ];
  systemd.services.sshd = {
    after = ["network-addresses-ifcadmin.service"];
    requires = ["network-addresses-ifcadmin.service"];
    serviceConfig = {
      RestartSec = "5";
    };
  };

  # Put Plex as a Docker container
  docker-containers = {
    plex = {
      image = "linuxserver/plex@sha256:e34eceb573f34aef705dac4a0b72b5b6542149ea7cd2709151cbccc456d43b07";

      extraDockerOptions = ["--network=host"];

      environment = {
        PUID = "193";
        PGID = "193";
        VERSION = "docker";
      };

      ports = [
        "32400:32400"
        "32400:32400/udp"
        "32469:32469"
        "32469:32469/udp"
        "5353:5353/udp"
        "1900:1900/udp"
      ];

      volumes = [
        "/var/lib/plex:/config"

        "/nas/Anime:/nas/Anime"
        "/nas/Cartoon:/nas/Cartoon"
        "/nas/Documentaries:/nas/Documentaries"
        "/nas/Movies:/nas/Movies"
        "/nas/MusicVideos:/nas/MusicVideos"
        "/nas/Plays:/nas/Plays"
        "/nas/Stand-upComedy:/nas/Stand-upComedy"
        "/nas/TVShows:/nas/TVShows"
      ];
    };
  };
  systemd.timers.docker-plex-backup = {
    wantedBy = [ "timers.target" ];
    partOf = [ "docker-plex-backup.service" ];
    timerConfig.OnCalendar = "daily";
  };
  systemd.services.docker-plex-backup = {
    serviceConfig.Type = "oneshot";
    script = ''
        ${pkgs.rsync}/bin/rsync -avuz --no-o --no-p --delete /var/lib/plex/Library/ /nas/Plex/Library/
    '';
  };

  #
  # Network
  #

  # TODO(high): For some reason, when the firewall is enabled, I can't seem to
  # connect via SSH.
  networking.firewall.enable = mkForce false;

  # disable the networkmanager on Zeus as it is really not needed since the
  # network does never change.
  networking.networkmanager.enable = false;

  networking.vlans = {
    # The ADMIN interface
    ifcadmin = {
      id = 2;
      interface = "enp0s31f6";
    };

    # SN0 interface
    ifcns0 = {
      id = 50;
      interface = "enp2s0f0";
    };

    # SN1 interface
    ifcns1 = {
      id = 51;
      interface = "enp2s0f1";
    };

    # SN2 interface
    ifcns2 = {
      id = 52;
      interface = "enp4s0f0";
    };

    # SN3 interface
    ifcns3 = {
      id = 53;
      interface = "enp4s0f1";
    };
  };

  networking.interfaces = {
    # turn off DHCP on all real interfaces, I use virtual networks.
    enp2s0f0 = { useDHCP = false; };
    enp2s0f1 = { useDHCP = false; };
    enp4s0f0 = { useDHCP = false; };
    enp4s0f1 = { useDHCP = false; };
    enp0s31f6 = { useDHCP = false; };

    # The ADMIN interface
    ifcadmin = {
      useDHCP = true;
    };

    # SN0 address
    ifcns0 = {
      useDHCP = true;
    };

    # SN1 address
    ifcns1 = {
      useDHCP = true;
    };

    # SN2 address
    ifcns2 = {
      useDHCP = true;
    };

    # SN3 address
    ifcns3 = {
      useDHCP = true;
    };
  };

  # This value detershabkas the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
