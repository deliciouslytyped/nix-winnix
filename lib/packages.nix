{lib, callPackage}:
let
  baseLayer = ../layers/0_base.nix;
  layers = [
    ../layers/1_config.nix
    ../layers/2_util.nix
    ../layers/3_packages.nix
    ];
  mkBase = lib.makeExtensible (callPackage baseLayer {});
  extend = a: a.extend;
in
  lib.foldl extend mkBase (map import layers)
