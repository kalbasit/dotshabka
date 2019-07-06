{
  mine.home-manager.config = { userName, uid, isAdmin, home, nixosConfig }:
  { lib, ... }:

  with lib;

  {
    imports = [
      <shabka/modules/home>
    ];

    mine.nixosConfig = nixosConfig;

    mine.neovim.enable = true;
    mine.pet.enable = true;
    mine.tmux.enable = true;
    mine.keyboard.layouts = [ "colemak" ];
  };
}
