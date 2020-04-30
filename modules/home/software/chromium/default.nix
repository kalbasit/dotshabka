# TODO(high): Surfingkeys must be composed of two files, the main one and the colemak bindings.
{ config, pkgs, lib, ... }:

with lib;

let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in {
  options.dotshabka.chromium.enable = mkEnableOption "Install and configure Chromium";
  options.dotshabka.chromium.surfingkeys.enable = mkEnableOption "Install and configure Surfingkeys";

  config = mkMerge [
    (mkIf (config.dotshabka.chromium.enable && isLinux) {
      home.file.".config/chromium/profiles/anya/.keep".text = "";
      home.file.".config/chromium/profiles/ihab/.keep".text = "";
      home.file.".config/chromium/profiles/keeptruckin/.keep".text = "";
      home.file.".config/chromium/profiles/nosecurity/.keep".text = "";
      home.file.".config/chromium/profiles/personal/.keep".text = "";
      home.file.".config/chromium/profiles/vanya/.keep".text = "";

      home.file.".config/chromium/profiles/nosecurity/.cmdline_args".text = "--disable-web-security";

      home.packages = with pkgs; [ chromium ];
    })

    (mkIf config.dotshabka.chromium.surfingkeys.enable {
      home.file.".surfingkeys.js".text = builtins.readFile (pkgs.substituteAll {
        src = ./surfingkeys.js;

        home_dir = "${config.home.homeDirectory}";
      });
    })
  ];
}
