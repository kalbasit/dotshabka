{
  shabka.workstation = {
    autorandr.enable = true;
    bluetooth.enable = true;
    fonts.enable = true;
    gnome-keyring.enable = true;
    keeptruckin.enable = true;
    networking.enable = true;
    power.enable = true;
    redshift.enable = true;
    sound.enable = true;
    teamviewer.enable = true;
    virtualbox.enable = true;
    xorg.enable = true;
  };

  shabka.users.users = {
    yl              = { uid = 2000; isAdmin = true;  home = "/yl"; };
    yl_opensource   = { uid = 2002; isAdmin = false; home = "/yl/opensource"; };
    yl_presentation = { uid = 2003; isAdmin = false; home = "/yl/presentation"; };
  };
}
