{ config, pkgs, lib, ... }:

with lib;

let
  shabka = import <shabka> {};

  dwarffs = (import shabka.external.edolstra.flake-compat.path { src = shabka.external.edolstra.dwarffs.path; }).defaultNix;
in { imports = [ dwarffs.nixosModules.dwarffs ]; }
