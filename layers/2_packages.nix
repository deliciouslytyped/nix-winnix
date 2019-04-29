#TODO documentation
#TODO im not sure the way i supply callpackages here is correct / sanely overridable? though you should be overriding at the base layer input probably
#POLICY: no built plugin may use binary files acquired from random repos, they must be built from source or acquired from official sources
self: super: {
#  path = ./mountpath;#TODO ugh
  wine = self.pkgs.winePackages.unstable.overrideAttrs (a: { patches = [ ./3_packages/wine/wine-3.21-patch ]; }); #TODO cant figure out why it wont build in parallel
  #TODO NOTE something something this is kind of obscure but we need to match the winetricks wine to wine so need to use self.winetricks not self.pkgs.winetricks for mkPrefix call
  winetricks = self.pkgs.winetricks.override { wine = self.wine; };

  #TODO test tag based json ontology / inf , keep metadata in second repo?
  cs2d = self.callPackage ./3_packages/cs2d.nix {}; #TODO auto-enumerate, encoding scheme for messy names
  ".kkrieger" = self.callPackage ./3_packages/.kkrieger.nix {};
  gta2-installer = self.callPackage ./3_packages/gta2-installer.nix {}; #TODO hands free installer
  gta2 = self.callPackage ./3_packages/gta2.nix {};
  "explorer++" = self.callPackage ./3_packages/explorer++.nix {};
  }
