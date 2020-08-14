{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in {
  options.dotshabka.brave.enable = mkEnableOption "Install and configure Brave";

  config = mkIf (config.dotshabka.brave.enable && isLinux) {
    home.file.".config/brave/profiles/personal/.keep".text = "";
    home.packages = with pkgs; [ brave ];
  };
}
