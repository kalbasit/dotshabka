let
  hashedPassword = "$6$0bx5eAEsHJRxkD8.$gJ7sdkOOJRf4QCHWLGDUtAmjHV/gJxPQpyCEtHubWocHh9O7pWy10Frkm1Ch8P0/m8UTUg.Oxp.MB3YSQxFXu1";
in
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
    yl              = { inherit hashedPassword; uid = 2000; isAdmin = true;  home = "/yl"; };
    yl_opensource   = { inherit hashedPassword; uid = 2002; isAdmin = false; home = "/yl/opensource"; };
    yl_presentation = { inherit hashedPassword; uid = 2003; isAdmin = false; home = "/yl/presentation"; };
  };
}
