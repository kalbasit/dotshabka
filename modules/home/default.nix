with import <shabka/util>;

{
  imports = recImport ./.;

  config.dotshabka.brave.enable = true;
  config.dotshabka.chromium.enable = true;
  config.dotshabka.chromium.surfingkeys.enable = true;
}
