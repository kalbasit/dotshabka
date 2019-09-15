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
      reader-port Yubico YubiKey
      disable-ccid
      card-timeout 5
    '';

    shabka.batteryNotifier.enable = true;
    shabka.git.enable = true;
    shabka.pijul.enable = true;
    shabka.gnupg.enable = true;
    shabka.keybase.enable = true;
    shabka.less.enable = true;
    shabka.neovim.enable = true;
    shabka.pet.enable = true;
    shabka.taskwarrior.enable = true;
    shabka.timewarrior.enable = true;
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
          wlan = [ "wlp2s0" ];
        };
        volume.enable = true;
        keyboardLayout.enable = true;
        temperature.enable = true;
      };
    };

    shabka.workstation.autorandr.enable = true;

    programs.autorandr.profiles = {
      "default" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0006af2d5b00000000001c0104a51d107803ee95a3544c99260f505400000001010101010101010101010101010101b43780a070383e403a2a350025a21000001a902c80a070383e403a2a350025a21000001a000000fe003036564736804231333348414e0000000000024122a8011100000a010a202000f1";
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
          eDP-1 = "00ffffffffffff0006af2d5b00000000001c0104a51d107803ee95a3544c99260f505400000001010101010101010101010101010101b43780a070383e403a2a350025a21000001a902c80a070383e403a2a350025a21000001a000000fe003036564736804231333348414e0000000000024122a8011100000a010a202000f1";
          DP-2-1 = "00ffffffffffff001e6df67628530600071a010380502278eaca95a6554ea1260f50542108007140818081c0a9c0b300d1c081000101e77c70a0d0a0295030203a00204f3100001a9d6770a0d0a0225030203a00204f3100001a000000fd00383d1e5a20000a202020202020000000fc004c4720554c545241574944450a018e02031ef12309070749100403011f13595a128301000067030c00200038409f3d70a0d0a0155030203a00204f3100001a7e4800e0a0381f4040403a00204f31000018011d007251d01e206e285500204f3100001e8c0ad08a20e02d10103e9600204f31000018000000ff003630374e54504343363530340a0000000000000026";
        };

        config = {
          eDP-1 = {
            enable = true;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:0.909:0.909";
            rate = "60.03";
          };

          DP-2-1 = {
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
          eDP-1 = "00ffffffffffff0006af2d5b00000000001c0104a51d107803ee95a3544c99260f505400000001010101010101010101010101010101b43780a070383e403a2a350025a21000001a902c80a070383e403a2a350025a21000001a000000fe003036564736804231333348414e0000000000024122a8011100000a010a202000f1";
          DP-1 = "00ffffffffffff0010aceb40535343410d1c0103803c22782aee95a3544c99260f5054a54b00714fa9408180d1c00101010101010101565e00a0a0a029503020350055502100001a000000ff003637594756383351414353530a000000fc0044454c4c205532373137440a20000000fd00324b1e5819000a2020202020200174020324f14f90050403020716010611121513141f23091f078301000067030c0010000032023a801871382d40582c450055502100001e7e3900a080381f4030203a0055502100001a011d007251d01e206e28550055502100001ebf1600a08038134030203a0055502100001a00000000000000000000000000000000000000b2";
        };

        config = {
          eDP-1 = {
            enable = true;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:0.909:0.909";
            rate = "60.03";
          };

          DP-1 = {
            enable = true;
            primary = true;
            position = "1920x0";
            mode = "2560x1440";
            gamma = "1.0:0.909:0.909";
            rate = "59.95";
          };
        };
      };
    };
  };
}
