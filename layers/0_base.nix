#TODO this is probably subltly broken but it seems to work! is lib the correct place to pull callpackagewith from?
{pkgs, lib}:
self: {
  inherit pkgs;

  callPackage = lib.callPackageWith ( self.pkgs ); #TODO is this ok? #TODO OH GOD WILL THIS ACTUALLY NOT BREAK?
#  callPackage = lib.callPackageWith ( self.pkgs // self ); #TODO is this ok? #TODO OH GOD WILL THIS ACTUALLY NOT BREAK?
  }
