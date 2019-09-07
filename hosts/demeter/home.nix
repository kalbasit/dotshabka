{
  shabka.home-manager.config = { userName, uid, isAdmin, home, nixosConfig }:
  { lib, ... }:

  with lib;

  {
    imports = [
      <shabka/modules/home>

      ../../modules/home
    ];

    shabka.nixosConfig = nixosConfig;

    shabka.git.enable = true;
    shabka.pijul.enable = true;
    shabka.keybase.enable = true;
    shabka.less.enable = true;
    shabka.neovim.enable = true;
    shabka.pet.enable = true;
    shabka.taskwarrior.enable = true;
    shabka.timewarrior.enable = true;
    shabka.tmux.enable = true;
    shabka.keyboard.layouts = [ "colemak" ];
  };
}
