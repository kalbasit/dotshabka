{
  shabka.home-manager.config = { darwinConfig }:
  { ... }:

  {
    imports = [
      <shabka/modules/home>
    ];

    shabka.darwinConfig = darwinConfig;

    shabka.git.enable = true;
    shabka.less.enable = true;
    shabka.neovim.enable = true;
    shabka.pet.enable = true;
    shabka.taskwarrior.enable = true;
    shabka.timewarrior.enable = true;
    shabka.tmux.enable = true;
    shabka.keyboard.layouts = [ "colemak" ];
  };
}
