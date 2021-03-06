{ lib, ... }:

with lib;

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  boot.initrd.luks.devices = {
    cryptkey     = { device = "/dev/disk/by-uuid/5993d93d-faa4-4007-9be2-d6a037c015eb"; };
    cryptroot    = { device = "/dev/disk/by-uuid/cd596953-67cc-49eb-be2f-095c8e9e5706"; keyFile = "/dev/mapper/cryptkey"; };
    cryptswap    = { device = "/dev/disk/by-uuid/eaec1f89-16fa-48ad-8cb9-11124545bb01"; keyFile = "/dev/mapper/cryptkey"; };
  };

  fileSystems = {
    "/"     = { device = "/dev/mapper/cryptroot"; fsType = "ext4"; };
    "/boot" = { device = "/dev/disk/by-uuid/AE56-BDC8"; fsType = "vfat"; };
  };

  swapDevices = [ { device = "/dev/mapper/cryptswap"; } ];
}
