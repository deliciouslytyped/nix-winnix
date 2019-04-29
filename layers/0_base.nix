{pkgs, lib}:
self: {
  inherit pkgs;

  #TODO I feel uncomfortable about doing this,
  #but it seems the be the way to make callpackage able to use both package sets
  # (wine packages take precedence)
  #TODO are there ways this could be subtly broken?
  #TODO should I get callPackageWith from lib or self.pkgs.lib?
  callPackage = lib.callPackageWith ( self.pkgs // self ); 
  }
