{
  shabka.home-manager.config = { darwinConfig }:
  { lib, ... }:

  {
    imports = [
      <shabka/modules/home>

      ../../modules/home
    ];

    shabka.darwinConfig = darwinConfig;

    shabka.git.enable = true;
    shabka.git.gpgSigningKey = lib.mkForce null;
    shabka.less.enable = true;
    shabka.neovim.enable = true;
    shabka.pet.enable = true;
    shabka.taskwarrior.enable = true;
    shabka.tmux.enable = true;
    shabka.keyboard.layouts = [ "colemak" ];
  };
}
