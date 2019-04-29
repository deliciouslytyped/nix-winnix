#TODO documentation / talk to upstream
#  with extensive use of overlay systems like this better infinite recursion debugging is absolutely necessary

#Example attrNames output of this approach (i removed noninteresting stuff):
#[ ".kkrieger" "UniExtract2" "callPackage" "combinePrefixWithPackages" "config" "cs2d" "explorer++" "extend" "gta2" "gta2-installer" "wine" "winetricks" "withPackages" ]

#TODO documentation
#TODO im not sure the way i supply callpackages here is correct / sanely overridable? though you should be overriding at the base layer input probably
#POLICY: no built plugin may use binary files acquired from random repos, they must be built from source or acquired from official sources
self: super: 
  let
    #TODO should this use unsafediscardstringcontext?
    #TODO using self as opposed to super causes infinite recursion for some reason
    result = 
      let
        dirFilter = (n: v: !(v == "directory"));
        #TODO rething the renamer approach, i already had a bug
        renamer = name: super.pkgs.lib.removeSuffix ".nix" name;
        importer = value: self.callPackage value {};
      in
        super.lib.pathMapAttrs dirFilter renamer importer ./4_packages;
  in
    {
    wine = self.pkgs.winePackages.unstable.overrideAttrs (a: { patches = [ ./4_packages/wine/wine-3.21-patch ]; }); #TODO cant figure out why it wont build in parallel
    #TODO NOTE something something this is kind of obscure but we need to match the winetricks wine to wine so need to use self.winetricks not self.pkgs.winetricks for mkPrefix call
    winetricks = self.pkgs.winetricks.override { wine = self.wine; };
      } // result #The order is so that you dont end up scratching your head why your file changes are doing nothing
