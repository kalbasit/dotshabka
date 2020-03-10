let
  secrets = import ../secrets/network/home.nix;
in {
  network.description = "Network at home, including my VPN on EC2";
  network.enableRollback = true;

  zeus = {
    imports = [ ../hosts/zeus/configuration.nix ];
    deployment.targetHost = "zeus.admin.nasreddine.com";
  };

  kore = {
    imports = [ ../hosts/kore/configuration.nix ];
    deployment.targetHost = "kore.admin.nasreddine.com";
  };

  xenia = {
    imports = [ ../hosts/xenia/configuration.nix ];
    deployment.targetHost = "xenia.admin.nasreddine.com";
  };

  resources = {
    ec2SecurityGroups = {
      "ssh-in" = {
        inherit (secrets) accessKeyId region;
        description = "Allow incoming SSH connection from anywhere";
        rules = [
          {fromPort = 22; toPort = 22; protocol = "tcp"; sourceIp = "0.0.0.0/0"; }
          # TODO(low): https://github.com/NixOS/nixops/issues/683
          # {fromPort = 22; toPort = 22; protocol = "tcp"; sourceIp = "::/0"; }
        ];
      };

      "vpn-in" = {
        inherit (secrets) accessKeyId region;
        description = "Allow incoming VPN connection from anywhere";
        rules = [
          {fromPort = 1194; toPort = 1194; protocol = "udp"; sourceIp = "0.0.0.0/0"; }
          # TODO(low): https://github.com/NixOS/nixops/issues/683
          # {fromPort = 1194; toPort = 1194; protocol = "udp"; sourceIp = "::/0"; }
        ];
      };
    };
  };

  vpn-nasreddine = { resources, ... }: {
    imports = [ ../hosts/vpn-nasreddine/configuration.nix ];
    deployment = {
      targetEnv = "ec2";

      ec2 = {
        inherit (secrets) accessKeyId region keyPair ami;

        instanceType = "t2.nano";
        ebsInitialRootDiskSize = 10;

        securityGroups = [
          resources.ec2SecurityGroups.ssh-in
          resources.ec2SecurityGroups.vpn-in
        ];
      };

      route53 = {
        inherit (secrets) accessKeyId;
        inherit (secrets.vpn) hostName;
        ttl = 300;
      };
    };
  };
}
