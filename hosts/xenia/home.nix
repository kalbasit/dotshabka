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

    shabka.neovim.enable = true;
    shabka.pet.enable = true;
    shabka.tmux.enable = true;
    shabka.keyboard.layouts = [ "colemak" ];
  };
}
