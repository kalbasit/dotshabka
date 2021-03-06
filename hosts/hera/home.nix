{
  shabka.home-manager.config = { userName, uid, isAdmin, home, nixosConfig }:
  { lib, ... }:

  with lib;

  {
    imports = [
      <shabka/modules/home>

      ../../modules/home
    ]
    ++ (optionals (builtins.pathExists ./../../secrets/home) (singleton ./../../secrets/home));

    shabka.nixosConfig = nixosConfig;

    home.file.".gnupg/scdaemon.conf".text = ''
      reader-port Yubico YubiKey FIDO+CCID 01 00
      disable-ccid
      card-timeout 5
    '';

    shabka.batteryNotifier.enable = true;
    shabka.git.enable = true;
    shabka.gnupg.enable = true;
    shabka.keybase.enable = true;
    shabka.less.enable = true;
    shabka.neovim.enable = true;
    shabka.pet.enable = true;
    shabka.taskwarrior.enable = true;
    shabka.tmux.enable = true;
    shabka.keyboard.layouts = [ "colemak" ];
    shabka.workstation.enable = true;

    shabka.workstation.i3.bar = {
      polybar.enable = true;
      modules = {
        backlight.enable = true;
        battery.enable = true;
        cpu.enable = true;
        time = {
          enable = true;

          timezones = [
            { timezone = "UTC"; prefix = "UTC"; format = "%H:%M:%S"; }
            { timezone = "America/Los_Angeles"; prefix = "PST"; format = "%H:%M:%S"; }
          ];
        };
        filesystems.enable = true;
        ram.enable = true;
        network = {
          enable = true;
          eth = [ "eno1" ];
          wlan = [ "wlp109s0" ];
        };
        volume.enable = true;
        temperature.enable = true;
      };
    };

    shabka.workstation.autorandr.enable = true;

    programs.autorandr.profiles = {
      "default" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0006afed6000000000001a0104952213780232a5a555529d260b505400000001010101010101010101010101010101143780a670382e406c30aa0058c11000001a102c80a670382e406c30aa0058c11000001a000000fe004a52385033804231353648414e00000000000041029e001000000a010a2020001b";
        };

        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:0.909:0.909";
            rate = "60.03";
          };
        };
      };

      "home" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0006afed6000000000001a0104952213780232a5a555529d260b505400000001010101010101010101010101010101143780a670382e406c30aa0058c11000001a102c80a670382e406c30aa0058c11000001a000000fe004a52385033804231353648414e00000000000041029e001000000a010a2020001b";
          DP-2 = "00ffffffffffff001e6de25a28530600071a0104a55022789eca95a6554ea1260f50542108007140818081c0a9c0b300d1c081000101e77c70a0d0a0295030203a00204f3100001a9d6770a0d0a0225030203a00204f3100001a000000fd00383d1e5a20000a202020202020000000fc004c4720554c545241574944450a01e4020316712309060749100403011f13595a12830100009f3d70a0d0a0155030203a00204f3100001a7e4800e0a0381f4040403a00204f31000018011d007251d01e206e285500204f3100001e8c0ad08a20e02d10103e9600204f31000018000000000000000000000000000000000000000000000000000000000000000000aa";
        };

        config = {
          eDP-1 = {
            enable = true;
            position = "0x360";
            mode = "1920x1080";
            gamma = "1.0:0.909:0.909";
            rate = "60.03";
          };

          DP-2 = {
            enable = true;
            primary = true;
            position = "1920x0";
            mode = "3440x1440";
            gamma = "1.0:0.909:0.909";
            rate = "59.97";
          };
        };
      };

      "work" = {
        fingerprint = {
          DP-2 = "00ffffffffffff0010acb8a04c3934322f1c0104a53420783a0495a9554d9d26105054a54b00714f8180a940d1c0d100010101010101283c80a070b023403020360006442100001e000000ff00434656394e38424b3234394c0a000000fc0044454c4c2055323431350a2020000000fd00313d1e5311000a202020202020011a02031cf14f9005040302071601141f12132021222309070783010000023a801871382d40582c450006442100001e011d8018711c1620582c250006442100009e011d007251d01e206e28550006442100001e8c0ad08a20e02d10103e96000644210000180000000000000000000000000000000000000000000000000000000c";
          DP-3 = "00ffffffffffff0010acbaa0554e3132331c010380342078ea0495a9554d9d26105054a54b00714f8180a940d1c0d100010101010101283c80a070b023403020360006442100001e000000ff00434656394e38434c32314e550a000000fc0044454c4c2055323431350a2020000000fd00313d1e5311000a2020202020200152020322f14f9005040302071601141f12132021222309070765030c00100083010000023a801871382d40582c450006442100001e011d8018711c1620582c250006442100009e011d007251d01e206e28550006442100001e8c0ad08a20e02d10103e960006442100001800000000000000000000000000000000000000000082";
          eDP-1 = "00ffffffffffff0006afed6000000000001a0104952213780232a5a555529d260b505400000001010101010101010101010101010101143780a670382e406c30aa0058c11000001a102c80a670382e406c30aa0058c11000001a000000fe004a52385033804231353648414e00000000000041029e001000000a010a2020001b";
        };

        config = {
          eDP-1 = { enable = false; };

          DP-2 = {
            enable = true;
            position = "0x0";
            mode = "1920x1200";
            gamma = "1.0:0.909:0.909";
            rate = "59.95";
          };

          DP-3 = {
            enable = true;
            primary = true;
            position = "1920x0";
            mode = "1920x1200";
            gamma = "1.0:0.909:0.909";
            rate = "59.95";
          };
        };
      };
    };
  };
}
